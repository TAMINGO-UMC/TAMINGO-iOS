// MARK: - TodoViewModel.swift
import SwiftUI

@Observable
class TodoViewModel {
    var todoItems: [TodoItem] = [
        TodoItem(title: "도서 반납", category: "일상", categoryColor: .daily, isCompleted: false, date: Date()),
        TodoItem(title: "책 읽기", category: "생활", categoryColor: .life, isCompleted: false, date: Date()),
        TodoItem(title: "도서 반납", category: "일상", categoryColor: .daily, isCompleted: false, date: Date().addingTimeInterval(86400)),
        TodoItem(title: "도서 반납", category: "일상", categoryColor: .daily, isCompleted: false, date: nil)
    ]
    
    var newTodoTitle: String = ""
    var selectedDate: Date = Date()
    var selectedWeekPeriod: WeekPeriod = .first
    var showingDatePicker: Bool = false
    var showingWeekDropdown: Bool = false
    var showingEditSheet: Bool = false
    var editingItem: TodoItem?
    
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
    
    /// AI 추론 결과를 포함하여 TodoItem 생성
    /// - aiResult가 nil이면 카테고리만 기본값("일상")으로 저장
    /// - location / estimatedMinutes는 nil → Sheet 편집 시 AI 기본값 표시됨
    func addTodo(aiResult: AIInferenceResult?) {
        guard !newTodoTitle.isEmpty else { return }
        
        let location: String?                    = aiResult?.location
        let estimatedMinutes: Int?               = aiResult.flatMap { Self.parseEstimatedTime($0.estimatedTime) }
        let category: String                     = aiResult?.category ?? "일상"
        let categoryColor: TodoItem.CategoryColor = Self.colorFor(category)
        
        let newItem = TodoItem(
            title: newTodoTitle,
            category: category,
            categoryColor: categoryColor,
            isCompleted: false,
            date: selectedDate,
            location: location,
            estimatedMinutes: estimatedMinutes
        )
        todoItems.append(newItem)
        newTodoTitle = ""
    }
    
    func toggleCompletion(for item: TodoItem) {
        guard let index = todoItems.firstIndex(where: { $0.id == item.id }) else { return }
        todoItems[index].isCompleted.toggle()
    }
    
    func editItem(_ item: TodoItem) {
        editingItem = item
        showingEditSheet = true
    }
    
    func deleteItem(_ item: TodoItem) {
        todoItems.removeAll { $0.id == item.id }
    }
    
    func updateItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index] = item
        }
    }
    
    // MARK: - Private Helpers
    
    /// "10분", "1시간 30분" 등의 문자열 → Int(총 분수)
    private static func parseEstimatedTime(_ timeString: String) -> Int? {
        var hours = 0, minutes = 0
        for part in timeString.components(separatedBy: " ") {
            if part.contains("시간"), let h = Int(part.replacingOccurrences(of: "시간", with: "")) {
                hours = h
            } else if part.contains("분"), let m = Int(part.replacingOccurrences(of: "분", with: "")) {
                minutes = m
            }
        }
        let total = hours * 60 + minutes
        return total > 0 ? total : nil
    }
    
    /// 카테고리 문자열 → TodoItem.CategoryColor
    private static func colorFor(_ category: String) -> TodoItem.CategoryColor {
        switch category {
        case "생활": return .life
        default:     return .daily
        }
    }
}
