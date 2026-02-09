//
//  TodoView.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: 입력창/캘린더 날짜 분리
//

import SwiftUI

struct ToDoView: View {
    @State private var viewModel = TodoViewModel()
    @State private var calendarViewModel = CalendarViewModel()
    
    @State private var showingCalendar = false
    @State private var isWeeklyCalendarExpanded = false
    
    // 입력창 캘린더용 (Optional Date 바인딩을 위한 중간 매개체)
    // 보여줄때는 inputDate ?? Date(), 선택하면 inputDate 업데이트
    var inputBoxDateBinding: Binding<Date> {
        Binding(
            get: { viewModel.inputDate ?? Date() },
            set: { viewModel.inputDate = $0 }
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Weekly Calendar (조회용 날짜)
                WeeklyCalendarView(
                    calendarViewModel: calendarViewModel,
                    isExpanded: $isWeeklyCalendarExpanded,
                    onDateSelected: { selectedDate in
                        viewModel.selectedDate = selectedDate
                        Task { await viewModel.loadTodos(for: selectedDate) }
                    }
                )
                
                // Input Box (입력용 날짜 - 독립적)
                TodoInputBox(
                    todoTitle: $viewModel.newTodoTitle,
                    selectedDate: $viewModel.inputDate,
                    showingDatePicker: $viewModel.showingDatePicker,
                    showingCalendar: $showingCalendar,
                    onAddTodo: { aiResult in
                        viewModel.addTodo(aiResult: aiResult)
                    }
                )
                
                // 오늘 할일 Section
                TodoSection(
                    headerTitle: "오늘 할 일",
                    headerDate: "\(formattedDate(viewModel.selectedDate)) (\(dayOfWeek(viewModel.selectedDate)))",
                    items: viewModel.dailyItems(),
                    onToggle: viewModel.toggleCompletion,
                    onEdit: viewModel.editItem
                )
                
                // 날짜 미지정 Section
                TodoSection(
                    headerTitle: "날짜 미지정",
                    headerDate: nil,
                    items: viewModel.backlogItems(),
                    onToggle: viewModel.toggleCompletion,
                    onEdit: viewModel.editItem
                )
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 21)
            .padding(.top, 20)
        }
        .task {
            await viewModel.loadTodos(for: Date())
        }
        .sheet(isPresented: $viewModel.showingEditSheet) {
            if let editingItem = viewModel.editingItem,
               let index = viewModel.todoItems.firstIndex(where: { $0.localId == editingItem.localId }) {
                TodoEditSheet(
                    isPresented: $viewModel.showingEditSheet,
                    item: $viewModel.todoItems[index]
                )
            }
        }
        .sheet(isPresented: $showingCalendar) {
            // 입력창 달력 시트
            CalendarSheetView(
                calendarViewModel: CalendarViewModel(), // 별도 인스턴스
                isPresented: $showingCalendar,
                selectedDate: inputBoxDateBinding
            )
        }
    }
    
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
