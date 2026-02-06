

import SwiftUI

@Observable
class TodoViewModel {
    var todoItems: [TodoItem] = []
    
    var newTodoTitle: String = ""
    var selectedDate: Date = Date()
    var selectedWeekPeriod: WeekPeriod = .first
    var showingDatePicker: Bool = false
    var showingWeekDropdown: Bool = false
    var showingEditSheet: Bool = false
    var editingItem: TodoItem?
    
    private let apiService = TodoAPIService.shared
    
    // TODO: 실제 카테고리 ID 매핑 필요 (서버에서 제공하는 카테고리 ID)
    // ScheduleTarget의 getCategories API를 통해 동적으로 가져올 수도 있음
    private let categoryIdMap: [String: Int] = [
        "일상": 1,
        "생활": 2,
        "업무": 3
    ]
    
    // MARK: - Filtering Methods
    func todayItems() -> [TodoItem] {
        let calendar = Calendar.current
        return todoItems.filter { item in
            guard let itemDate = item.date else { return false }
            return calendar.isDateInToday(itemDate)
        }
    }
    
    func tomorrowItems() -> [TodoItem] {
        let calendar = Calendar.current
        return todoItems.filter { item in
            guard let itemDate = item.date else { return false }
            return calendar.isDateInTomorrow(itemDate)
        }
    }
    
    func undatedItems() -> [TodoItem] {
        return todoItems.filter { $0.date == nil }
    }
    
    // MARK: - Actions
    
    /// AI 추론 결과를 포함하여 TodoItem 생성 및 서버 전송
    func addTodo(aiResult: AIInferenceResult?) {
        guard !newTodoTitle.isEmpty else { return }
        
        // AI 결과로부터 정보 추출
        let category = aiResult?.category ?? "미지정"
        let categoryColor = TodoItem.CategoryColor.from(category: category)
        let todoCategoryId = categoryIdMap[category] ?? 1
        
        // 로컬 TodoItem 생성 (id는 nil - 서버 응답 후 업데이트)
        var newItem = TodoItem(
            id: nil,
            title: newTodoTitle,
            category: category,
            categoryColor: categoryColor,
            isCompleted: false,
            date: selectedDate,
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
        
        // 서버에 전송
        Task {
            do {
                let requestDTO = newItem.toCreateRequestDTO(todoCategoryId: todoCategoryId)
                let response = try await apiService.createTodo(body: requestDTO)
                
                await MainActor.run {
                    // 서버에서 받은 ID로 업데이트
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
                }
            } catch let error as APIError {
                await MainActor.run {
                    print("할 일 생성 실패: \(error.errorDescription ?? "알 수 없는 오류")")
                    // TODO: 사용자에게 에러 알림 표시
                }
            } catch {
                await MainActor.run {
                    print("할 일 생성 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 할일 완료 상태 토글 (서버 동기화)
    func toggleCompletion(for item: TodoItem) {
        guard let itemId = item.id,
              let index = todoItems.firstIndex(where: { $0.localId == item.localId }) else {
            return
        }
        
        let newCompletionState = !todoItems[index].isCompleted
        
        // UI 즉시 업데이트
        todoItems[index].isCompleted = newCompletionState
        
        // 서버 동기화
        Task {
            do {
                _ = try await apiService.updateTodoCompletion(
                    id: itemId,
                    isChecked: newCompletionState
                )
            } catch {
                // 실패 시 원복
                await MainActor.run {
                    if let idx = todoItems.firstIndex(where: { $0.localId == item.localId }) {
                        todoItems[idx].isCompleted = !newCompletionState
                    }
                    print("완료 상태 업데이트 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 할일 편집 시트 열기 (서버에서 최신 데이터 가져오기)
    func editItem(_ item: TodoItem) {
        guard let itemId = item.id else {
            // ID가 없으면 로컬 데이터로 편집
            editingItem = item
            showingEditSheet = true
            return
        }
        
        Task {
            do {
                let detailDTO = try await apiService.getTodoDetail(id: itemId)
                let updatedItem = detailDTO.toTodoItem()
                
                await MainActor.run {
                    editingItem = updatedItem
                    showingEditSheet = true
                }
            } catch {
                await MainActor.run {
                    // 실패 시 로컬 데이터로 편집
                    editingItem = item
                    showingEditSheet = true
                    print("할 일 상세 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 할일 삭제
    func deleteItem(_ item: TodoItem) {
        guard let itemId = item.id else {
            // ID가 없으면 로컬에서만 삭제
            todoItems.removeAll { $0.localId == item.localId }
            return
        }
        
        // 로컬에서 즉시 삭제
        todoItems.removeAll { $0.localId == item.localId }
        
        // TODO: 서버 삭제 API 추가 필요
        // 현재 API 문서에 삭제 API가 없음
    }
    
    /// 할일 업데이트 (편집 시트에서 저장 시)
    func updateItem(_ item: TodoItem) {
        guard let itemId = item.id,
              let todoCategoryId = categoryIdMap[item.category] else {
            // ID가 없거나 카테고리 매핑 실패 시 로컬만 업데이트
            if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
                todoItems[index] = item
            }
            return
        }
        
        // 로컬 즉시 업데이트
        if let index = todoItems.firstIndex(where: { $0.localId == item.localId }) {
            todoItems[index] = item
        }
        
        // 서버 동기화
        Task {
            do {
                let requestDTO = item.toUpdateRequestDTO(todoCategoryId: todoCategoryId)
                _ = try await apiService.updateTodo(id: itemId, body: requestDTO)
            } catch {
                await MainActor.run {
                    print("할 일 업데이트 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - WeekPeriod
enum WeekPeriod: String, CaseIterable {
    case first = "첫째 주"
    case second = "둘째 주"
    case third = "셋째 주"
    case fourth = "넷째 주"
}
