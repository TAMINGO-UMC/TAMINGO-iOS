//
//  TodoViewModel.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: 2/9/26 - categoryIdMap 확장 및 디버깅 로그 추가
//  Updated: 2/12/26 - toUpdateRequestDTO 호출 시 Optional Unwrapping 오류 수정
//

import SwiftUI

@Observable
class TodoViewModel {
    var todoItems: [TodoItem] = []
    
    var newTodoTitle: String = ""
    
    // 1. 캘린더용 날짜 (리스트 조회 기준)
    var selectedDate: Date = Date()
    
    // 2. 입력창용 날짜 (기본값 nil -> 미지정)
    var inputDate: Date? = nil
    
    var showingDatePicker: Bool = false
    var showingEditSheet: Bool = false
    var editingItem: TodoItem?
    
    private let apiService = TodoAPIService.shared
    
    // MARK: - 할일 목록 조회
    func loadTodos(for date: Date) async {
        let dateString = date.toAPIDateString()
        do {
            let response = try await apiService.getTodoList(date: dateString)
            await MainActor.run {
                let dailyItems = response.dailyTodos.map { dto -> TodoItem in
                    var item = dto.toTodoItem()
                    item.date = date
                    return item
                }
                let backlogItems = response.backlogTodos.map { dto -> TodoItem in
                    var item = dto.toTodoItem()
                    item.date = nil
                    return item
                }
                self.todoItems = dailyItems + backlogItems
            }
        } catch {
            await MainActor.run {
                print("할일 목록 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Filtering Methods
    func dailyItems() -> [TodoItem] {
        let calendar = Calendar.current
        return todoItems.filter { item in
            guard let itemDate = item.date else { return false }
            return calendar.isDate(itemDate, inSameDayAs: selectedDate)
        }
    }
    
    func backlogItems() -> [TodoItem] {
        return todoItems.filter { $0.date == nil }
    }
    
    func addTodo(aiResult: AIInferenceResult?) {
        guard !newTodoTitle.isEmpty else { return }
        
        let categoryId = aiResult?.categoryId
        let category = aiResult?.category ?? "미지정"
        let color = aiResult?.categoryColor ?? Color.gray
        
        // 1. 처음 생성 시 let으로 선언하여 캡처 안전성 확보
        let initialItem = TodoItem(
            id: nil,
            title: newTodoTitle,
            categoryId: categoryId,
            category: category,
            categoryColor: color,
            isCompleted: false,
            date: inputDate,
            placeName: aiResult?.placeName,
            address: aiResult?.address,
            latitude: aiResult?.latitude,
            longitude: aiResult?.longitude,
            estimatedMinutes: aiResult?.duration,
            aiSource: aiResult.map { result in
                TodoItem.AISourceInfo(
                    aiSuggestedCategoryName: result.category,
                    aiSuggestedPlaceName: result.placeName,
                    aiSuggestedDuration: result.duration
                )
            }
        )
        
        Task {
            do {
                let requestDTO = initialItem.toCreateRequestDTO(todoCategoryId: categoryId)
                let response = try await apiService.createTodo(body: requestDTO)
                
                // 2. MainActor로 보낼 때 필요한 데이터를 미리 상수로 추출
                let newId = response.todoId
                
                await MainActor.run {
                    // 3. 기존의 initialItem 정보를 바탕으로 새로운 인스턴스 생성
                    var updatedItem = initialItem
                    updatedItem.id = newId
                    
                    // Observable 배열에 추가
                    self.todoItems.append(updatedItem)
                    self.newTodoTitle = ""
                }
            } catch {
                await MainActor.run { print("할 일 생성 실패: \(error.localizedDescription)") }
            }
        }
    }
    
    func toggleCompletion(for item: TodoItem) {
        guard let itemId = item.id,
              let index = todoItems.firstIndex(where: { $0.localId == item.localId }) else { return }
        
        let newCompletionState = !todoItems[index].isCompleted
        todoItems[index].isCompleted = newCompletionState
        
        Task {
            do {
                _ = try await apiService.updateTodoCompletion(id: itemId, isChecked: newCompletionState)
            } catch {
                await MainActor.run {
                    if let idx = todoItems.firstIndex(where: { $0.localId == item.localId }) {
                        todoItems[idx].isCompleted = !newCompletionState
                    }
                }
            }
        }
    }
    
    // MARK: - 할 일 편집
    func editItem(_ item: TodoItem) {
        guard let itemId = item.id else {
            editingItem = item
            showingEditSheet = true
            return
        }
        
        Task {
            do {
                let detailDTO = try await apiService.getTodoDetail(id: itemId)
                let fetchedItem = detailDTO.toTodoItem()
                
                await MainActor.run {
                    if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
                        var targetItem = todoItems[index]
                        
                        targetItem.title = fetchedItem.title
                        targetItem.category = fetchedItem.category
                        targetItem.categoryColor = fetchedItem.categoryColor
                        targetItem.date = fetchedItem.date
                        
                        targetItem.placeName = fetchedItem.placeName
                        targetItem.address = fetchedItem.address
                        targetItem.latitude = fetchedItem.latitude
                        targetItem.longitude = fetchedItem.longitude
                        
                        targetItem.estimatedMinutes = fetchedItem.estimatedMinutes
                        
                        // relatedSchedules 및 linkedScheduleId 복원
                        targetItem.relatedSchedules = fetchedItem.relatedSchedules
                        targetItem.linkedScheduleId = fetchedItem.linkedScheduleId
                        
                        targetItem.isRoutineEnabled = fetchedItem.isRoutineEnabled
                        targetItem.routineType = fetchedItem.routineType
                        targetItem.routineEndDate = fetchedItem.routineEndDate
                        
                        print("✅ editItem - 서버 데이터 복원 완료")
                        print("  - date: \(targetItem.date?.toAPIDateString() ?? "nil")")
                        print("  - linkedScheduleId: \(targetItem.linkedScheduleId ?? -1)")
                        print("  - relatedSchedules 수: \(targetItem.relatedSchedules.count)")
                        print("  - 선택된 스케줄 수: \(targetItem.relatedSchedules.filter { $0.isSelected }.count)")
                        
                        todoItems[index] = targetItem
                        editingItem = targetItem
                        showingEditSheet = true
                    } else {
                        editingItem = fetchedItem
                        showingEditSheet = true
                    }
                }
            } catch {
                await MainActor.run {
                    print("할 일 상세 조회 실패: \(error.localizedDescription)")
                    editingItem = item
                    showingEditSheet = true
                }
            }
        }
    }
    
    // MARK: - 할 일 삭제
    func deleteItem(_ item: TodoItem) {
        guard let itemId = item.id else {
            todoItems.removeAll { $0.localId == item.localId }
            return
        }
        
        if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
            todoItems.remove(at: index)
        }
        
        Task {
            do {
                try await apiService.deleteTodo(id: itemId)
            } catch {
                print("삭제 실패: \(error)")
                await loadTodos(for: selectedDate)
            }
        }
    }
    
    // MARK: - 할 일 업데이트
    func updateItem(_ item: TodoItem) {
        // ✅ 디버깅 로그 추가
        print("🔵 updateItem 호출됨")
        print("  - item.id: \(item.id ?? -1)")
        print("  - item.title: \(item.title)")
        print("  - item.categoryId: \(item.categoryId ?? -1)")
        print("  - item.category: \(item.category)")
        print("  - item.date: \(item.date?.toAPIDateString() ?? "nil (backlog)")")
        print("  - linkedScheduleId: \(item.linkedScheduleId ?? -1)")
        
        guard let itemId = item.id else {
            print("❌ item.id가 nil - 서버 업데이트 건너뜀")
            if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
                todoItems[index] = item
            }
            return
        }
        
        // ✅ categoryId 사용 (없으면 nil)
        let todoCategoryId = item.categoryId
        print("✅ todoCategoryId: \(todoCategoryId ?? -1)")
        
        // 로컬 업데이트 (임시)
        if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
            todoItems[index] = item
            print("✅ 로컬 todoItems 업데이트 완료 (index: \(index))")
        }
        
        // 서버 업데이트
        Task {
            do {
                // ✅ [수정] todoCategoryId가 Optional(Int?)이므로 nil일 경우 기본값(0)을 주어 Int 타입으로 맞춤
                let requestDTO = item.toUpdateRequestDTO(todoCategoryId: todoCategoryId ?? 0)
                
                print("🔵 PUT 요청 시작 - /api/todos/\(itemId)")
                print("  - Request DTO: \(requestDTO)")
                
                let response = try await apiService.updateTodo(id: itemId, body: requestDTO)
                
                print("✅ PUT 요청 성공")
                print("  - actualTargetDate: \(response.actualTargetDate ?? "nil")")
                
                // ✅ 서버가 반환한 실제 날짜로 동기화
                await MainActor.run {
                    if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
                        if let actualDateString = response.actualTargetDate,
                           let actualDate = actualDateString.toDates() {
                            todoItems[index].date = actualDate
                            selectedDate = actualDate
                            print("📅 날짜 동기화 완료: \(actualDateString)")
                        }
                    }
                }
                
                // ✅ 동기화된 날짜로 목록 재조회
                let targetDate = response.actualTargetDate?.toDates() ?? item.date ?? selectedDate
                print("📅 목록 재조회 날짜: \(targetDate.toAPIDateString())")
                
                await loadTodos(for: targetDate)
            } catch {
                print("❌ 할 일 업데이트 실패: \(error)")
            }
        }
    }
}
