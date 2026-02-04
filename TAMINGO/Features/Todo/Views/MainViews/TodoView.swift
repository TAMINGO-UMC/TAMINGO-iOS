import SwiftUI

struct ToDoView: View {
    @State private var viewModel = TodoViewModel()
    @State private var calendarViewModel = CalendarViewModel()
    @State private var showingCalendar = false
    @State private var isWeeklyCalendarExpanded = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Weekly Calendar
                WeeklyCalendarView(
                    calendarViewModel: calendarViewModel,
                    isExpanded: $isWeeklyCalendarExpanded,
                    onDateSelected: { selectedDate in
                        viewModel.selectedDate = selectedDate
                    }
                )
                
                // Input Box
                TodoInputBox(
                    todoTitle: $viewModel.newTodoTitle,
                    selectedDate: $viewModel.selectedDate,
                    showingDatePicker: $viewModel.showingDatePicker,
                    showingCalendar: $showingCalendar,
                    onAddTodo: { aiResult in
                        viewModel.addTodo(aiResult: aiResult)
                    }
                )
                
                // Today Section
                TodoSection(
                    headerTitle: "오늘 할일",
                    headerDate: "\(formattedDate(Date())) (\(dayOfWeek(Date())))",
                    items: viewModel.todayItems(),
                    onToggle: viewModel.toggleCompletion,
                    onEdit: viewModel.editItem
                )
                
                // Tomorrow Section
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                TodoSection(
                    headerTitle: "내일 할일",
                    headerDate: "\(formattedDate(tomorrow)) (\(dayOfWeek(tomorrow)))",
                    items: viewModel.tomorrowItems(),
                    onToggle: viewModel.toggleCompletion,
                    onEdit: viewModel.editItem
                )
                
                // Undated Section
                TodoSection(
                    headerTitle: "날짜 미지정",
                    headerDate: nil,
                    items: viewModel.undatedItems(),
                    onToggle: viewModel.toggleCompletion,
                    onEdit: viewModel.editItem
                )
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 21)
            .padding(.top, 20)
        }
        .sheet(isPresented: $viewModel.showingEditSheet) {
            if let editingItem = viewModel.editingItem,
               let index = viewModel.todoItems.firstIndex(where: { $0.id == editingItem.id }) {
                TodoEditSheet(
                    isPresented: $viewModel.showingEditSheet,
                    item: $viewModel.todoItems[index]
                )
            }
        }
        .sheet(isPresented: $showingCalendar) {
            CalendarSheetView(
                calendarViewModel: calendarViewModel,
                isPresented: $showingCalendar,
                selectedDate: $viewModel.selectedDate
            )
        }
    }
    
    // MARK: - Helper Functions
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
    
    private func dayOfWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    ToDoView()
}
