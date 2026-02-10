//
//  TodoView.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: 2/9/26 - TodoWeeklyCalendarView 사용 (마커 지원)
//

import SwiftUI

struct ToDoView: View {
    @State private var viewModel = TodoViewModel()
    @State private var weeklyCalendarViewModel = TodoWeeklyCalendarViewModel()
    
    @State private var showingCalendar = false
    @State private var isWeeklyCalendarExpanded = false
    
    // 입력창 캘린더용 (Optional Date 바인딩을 위한 중간 매개체)
    var inputBoxDateBinding: Binding<Date> {
        Binding(
            get: { viewModel.inputDate ?? Date() },
            set: { viewModel.inputDate = $0 }
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // ✅ Todo 전용 Weekly Calendar (마커 지원)
                TodoWeeklyCalendarView(
                    viewModel: weeklyCalendarViewModel,
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
            updateCalendarMarkers()
        }
        // MARK: - ✅ [수정됨] 저장/삭제 핸들러 연결
        .sheet(isPresented: $viewModel.showingEditSheet) {
            if let editingItem = viewModel.editingItem,
               let index = viewModel.todoItems.firstIndex(where: { $0.id == editingItem.id }) {
                
                TodoEditSheet(
                    isPresented: $viewModel.showingEditSheet,
                    item: $viewModel.todoItems[index],
                    // 1. 저장 버튼 클릭 시 -> ViewModel 업데이트 함수 호출 (서버 통신)
                    onSave: { updatedItem in
                        viewModel.updateItem(updatedItem)
                        
                        // ✅ 저장 후 캘린더를 할 일의 날짜로 이동
                        if let itemDate = updatedItem.date {
                            viewModel.selectedDate = itemDate
                            weeklyCalendarViewModel.selectDate = itemDate
                        }
                        
                        // ✅ 마커 업데이트
                        updateCalendarMarkers()
                    },
                    // 2. 삭제 버튼 클릭 시 -> ViewModel 삭제 함수 호출 (서버 통신)
                    onDelete: { deletedItem in
                        viewModel.deleteItem(deletedItem)
                        updateCalendarMarkers()
                    }
                )
            }
        }
        .sheet(isPresented: $showingCalendar) {
            WheelDatePickerSheet(
                selectedDate: inputBoxDateBinding,
                isPresented: $showingCalendar
            )
        }
        // ✅ showingDatePicker 시트 (WheelDatePicker)
        .sheet(isPresented: $viewModel.showingDatePicker) {
            WheelDatePickerSheet(
                selectedDate: inputBoxDateBinding,
                isPresented: $viewModel.showingDatePicker
            )
        }
        .onChange(of: viewModel.todoItems) {
            updateCalendarMarkers()
        }
    }
    
    // MARK: - 캘린더 마커 업데이트
    private func updateCalendarMarkers() {
        weeklyCalendarViewModel.clearAllMarkers()
        
        for item in viewModel.todoItems {
            guard let date = item.date else { continue }
            weeklyCalendarViewModel.addMarker(
                for: date,
                color: item.categoryColor,
                category: item.category
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
