//
//  TodoViewModel.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: ID 불일치 문제 해결 (Stub 대응)
//

import SwiftUI

@Observable
class TodoViewModel {
    var todoItems: [TodoItem] = []
    
    var newTodoTitle: String = ""
    
    // 1. 캘린더용 날짜 (리스트 조회 기준)
    var selectedDate: Date = Date()
    
    // 2. 입력창용 날짜 (기본값 nil -> 미지정)
    // 캘린더 날짜와 독립적으로 동작
    var inputDate: Date? = nil
    
    var showingDatePicker: Bool = false
    var showingEditSheet: Bool = false
    var editingItem: TodoItem?
    
    private let apiService = TodoAPIService.shared
    
    private let categoryIdMap: [String: Int] = [
        "일상": 1, "생활": 2, "업무": 3
    ]
    
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
    
    // MARK: - Actions
    func addTodo(aiResult: AIInferenceResult?) {
        guard !newTodoTitle.isEmpty else { return }
        
        let category = aiResult?.category ?? "미지정"
        let categoryColor = CategoryColor(rawValue: category) ?? .mint
        let todoCategoryId = categoryIdMap[category] ?? 1
        
        // inputDate 사용 (nil이면 미지정)
        var newItem = TodoItem(
            id: nil,
            title: newTodoTitle,
            category: category,
            categoryColor: categoryColor,
            isCompleted: false,
            date: inputDate, // ✅ 입력창 날짜 사용
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
                let requestDTO = newItem.toCreateRequestDTO(todoCategoryId: todoCategoryId)
                let response = try await apiService.createTodo(body: requestDTO)
                
                await MainActor.run {
                    newItem = TodoItem(
                        id: response.todoId,
                        title: newItem.title,
                        category: newItem.category,
                        categoryColor: newItem.categoryColor,
                        isCompleted: newItem.isCompleted,
                        date: newItem.date,
                        placeName: newItem.placeName,
                        address: newItem.address,
                        latitude: newItem.latitude,
                        longitude: newItem.longitude,
                        estimatedMinutes: newItem.estimatedMinutes,
                        aiSource: newItem.aiSource
                    )
                    todoItems.append(newItem)
                    newTodoTitle = ""
                    // 필요 시 inputDate = nil 초기화 가능
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
    
    // MARK: - 할 일 편집 (ID 불일치 해결 로직 적용)
    func editItem(_ item: TodoItem) {
        // 1. 아직 서버에 저장되지 않은(로컬) 아이템인 경우 바로 수정 모드 진입
        guard let itemId = item.id else {
            editingItem = item
            showingEditSheet = true
            return
        }
        
        Task {
            do {
                // 2. 서버에서 최신 상세 정보 가져오기 (Stub 사용 시 ID 18 반환됨)
                let detailDTO = try await apiService.getTodoDetail(id: itemId)
                let fetchedItem = detailDTO.toTodoItem()
                
                await MainActor.run {
                    // 3. 리스트에서 '수정 버튼을 누른 원본 아이템' 찾기 (localId 이용)
                    if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
                        
                        // 4. [핵심] ID는 원본(리스트에 있는 것)을 유지하고, 내용만 서버 데이터로 업데이트
                        // 이렇게 해야 View에서 ID로 매칭할 때 실패하지 않음
                        
                        var targetItem = todoItems[index]
                        
                        // 내용 덮어쓰기 (ID 제외한 var 프로퍼티들)
                        targetItem.title = fetchedItem.title
                        targetItem.category = fetchedItem.category
                        targetItem.categoryColor = fetchedItem.categoryColor
                        // targetItem.isCompleted = fetchedItem.isCompleted // 상세조회엔 완료여부가 없는 경우가 많음
                        targetItem.date = fetchedItem.date
                        
                        targetItem.placeName = fetchedItem.placeName
                        targetItem.address = fetchedItem.address
                        targetItem.latitude = fetchedItem.latitude
                        targetItem.longitude = fetchedItem.longitude
                        
                        targetItem.estimatedMinutes = fetchedItem.estimatedMinutes
                        targetItem.relatedSchedules = fetchedItem.relatedSchedules
                        targetItem.linkedScheduleId = fetchedItem.linkedScheduleId
                        
                        targetItem.isRoutineEnabled = fetchedItem.isRoutineEnabled
                        targetItem.routineType = fetchedItem.routineType
                        targetItem.routineEndDate = fetchedItem.routineEndDate
                        
                        // 5. 리스트 업데이트 및 시트 활성화
                        todoItems[index] = targetItem
                        editingItem = targetItem
                        showingEditSheet = true
                        
                    } else {
                        // 만약 리스트에서 못 찾았다면(거의 없겠지만), 그냥 받아온거라도 띄움
                        editingItem = fetchedItem
                        showingEditSheet = true
                    }
                }
            } catch {
                await MainActor.run {
                    print("할 일 상세 조회 실패: \(error.localizedDescription)")
                    // 에러나면 기존 정보로라도 띄움
                    editingItem = item
                    showingEditSheet = true
                }
            }
        }
    }
    
    // MARK: - 할 일 삭제
    func deleteItem(_ item: TodoItem) {
        guard let itemId = item.id else {
            // 로컬 아이템은 바로 삭제
            todoItems.removeAll { $0.localId == item.localId }
            return
        }
        
        // Optimistic Update
        if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
            todoItems.remove(at: index)
        }
        
        Task {
            do {
                try await apiService.deleteTodo(id: itemId)
            } catch {
                print("삭제 실패: \(error)")
                // 실패 시 목록 다시 불러오기 (롤백)
                await loadTodos(for: selectedDate)
            }
        }
    }
    
    // MARK: - 할 일 업데이트
    func updateItem(_ item: TodoItem) {
        guard let itemId = item.id,
              let todoCategoryId = categoryIdMap[item.category] else {
            if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
                todoItems[index] = item
            }
            return
        }
        
        if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
            todoItems[index] = item
        }
        
        Task {
            do {
                let requestDTO = item.toUpdateRequestDTO(todoCategoryId: todoCategoryId)
                _ = try await apiService.updateTodo(id: itemId, body: requestDTO)
                await loadTodos(for: selectedDate)
            } catch {
                print("할 일 업데이트 실패: \(error)")
            }
        }
    }
}
