//
//  TodoEditSheet.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct TodoEditSheet: View {
    @Binding var isPresented: Bool
    @Binding var item: TodoItem
    @State private var viewModel: TodoEditViewModel
    @State private var calendarViewModel = CalendarViewModel()
    @State private var showingCalendar = false
    
    /// CalendarSheet에 올림되는 날짜
    /// - viewModel.selectedDate가 nil이면 오늘로 표시되지만,
    ///   확인 버튼 눌러야 viewModel에 날짜가 세팅됨
    @State private var calendarSelectedDate: Date = Date()
    
    init(isPresented: Binding<Bool>, item: Binding<TodoItem>) {
        self._isPresented = isPresented
        self._item = item
        self._viewModel = State(initialValue: TodoEditViewModel(item: item.wrappedValue))
        // 초기값: item.date가 있으면 그 날짜, 없으면 오늘
        self._calendarSelectedDate = State(initialValue: item.wrappedValue.date ?? Date())
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                    Header(isPresented: $isPresented)
                    
                    TitleSection(title: $viewModel.title)
                    
                    // isUndated: selectedDate가 nil이면 미지정 표현
                    DateSection(
                        formattedDate: viewModel.formattedDate,
                        isUndated: viewModel.selectedDate == nil,
                        showingCalendar: $showingCalendar
                    )
                    
                    LocationSection(viewModel: $viewModel)
                    
                    DurationSection(viewModel: $viewModel)
                    
                    CategorySections(isCategoryAIGenerated: viewModel.isCategoryAIGenerated)
                    
                    RelateSchedule(viewModel: $viewModel)
                    
                    RoutineSection(
                        isRoutineEnabled: $viewModel.isRoutineEnabled,
                        selectedRoutine: $viewModel.selectedRoutine,
                        routineEndDate: $viewModel.routineEndDate,
                        hasEndDate: $viewModel.hasEndDate
                    )
                    
                    BottomButtons(
                        viewModel: $viewModel,
                        item: $item,
                        isPresented: $isPresented
                    )
                }
                .padding(.horizontal, 21)
                .padding(.top, 20)
            }
            .sheet(isPresented: $showingCalendar) {
                // CalendarSheet은 항상 Date (non-optional)을 받음
                // calendarSelectedDate로 중간 완충 → 확인 시 viewModel에 전달
                CalendarDatePickerSheet(
                    calendarViewModel: calendarViewModel,
                    isPresented: $showingCalendar,
                    selectedDate: $calendarSelectedDate,
                    onConfirm: { date in
                        viewModel.selectedDate = date   // 미지정 → 날짜 지정
                    }
                )
            }
        }
    }
}

// MARK: - CalendarDatePickerSheet
/// CalendarSheetView를 감싸는 래퍼
/// - 확인 버튼 클릭 시에만 날짜를 부모에 전달 (onConfirm)
/// - 닫기 버튼으로 닫으면 변경 없음 (미지정 유지)
struct CalendarDatePickerSheet: View {
    @State var calendarViewModel: CalendarViewModel
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date
    let onConfirm: (Date) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CalendarView(
                    calendarViewModel: calendarViewModel,
                    enableSwipe: true,
                    contentPadding: 20,
                    onDateSelected: { date in
                        selectedDate = date
                    },
                    onAddPress: nil
                )
                
                // 확인 버튼 → onConfirm으로 날짜 전달
                Button(action: {
                    onConfirm(selectedDate)
                    isPresented = false
                }) {
                    Text("확인")
                        .font(.medium14)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.mainMint)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Spacer()
            }
            .navigationTitle("날짜 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        isPresented = false   // 날짜 변경 없이 닫기
                    }
                    .foregroundColor(.gray2)
                }
            }
        }
    }
}
