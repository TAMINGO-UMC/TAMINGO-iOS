//
//  TodoEditSheet.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//  Updated: CalendarSheetView 적용 및 날짜 동기화
//

import SwiftUI

struct TodoEditSheet: View {
    @Binding var isPresented: Bool
    @Binding var item: TodoItem
    @State private var viewModel: TodoEditViewModel
    @State private var calendarViewModel = CalendarViewModel()
    @State private var showingCalendar = false
    
    // 캘린더 시트용 임시 날짜 상태
    @State private var calendarSelectedDate: Date = Date()
    
    init(isPresented: Binding<Bool>, item: Binding<TodoItem>) {
        self._isPresented = isPresented
        self._item = item
        let viewModel = TodoEditViewModel(item: item.wrappedValue)
        self._viewModel = State(initialValue: viewModel)
        // ViewModel의 selectedDate를 사용하여 초기화 (이미 item.date로 설정됨)
        self._calendarSelectedDate = State(initialValue: viewModel.selectedDate ?? Date())
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                    Header(isPresented: $isPresented)
                    
                    // 제목 변경 시 ViewModel 호출
                    TitleSection(title: Binding(
                        get: { viewModel.title },
                        set: { viewModel.onTitleChanged($0) }
                    ))
                    
                    DateSection(
                        formattedDate: viewModel.formattedDate,
                        isUndated: viewModel.selectedDate == nil,
                        showingCalendar: $showingCalendar
                    )
                    
                    LocationSection(viewModel: $viewModel)
                    
                    DurationSection(viewModel: $viewModel)
                    
                    CategorySections(
                        isCategoryAIGenerated: viewModel.isCategoryAIGenerated,
                        isInferring: viewModel.isInferringCategory
                    )
                    
                    RelateSchedule(viewModel: $viewModel)
                    
                    RoutineSection(viewModel: $viewModel)
                    
                    BottomButtons(
                        viewModel: $viewModel,
                        item: $item,
                        isPresented: $isPresented
                    )
                }
                .padding(.horizontal, 21)
                .padding(.top, 20)
            }
            .task {
                await viewModel.loadMyPlaces()
            }
            .sheet(isPresented: $showingCalendar) {
                CalendarSheetView(
                    calendarViewModel: calendarViewModel,
                    isPresented: $showingCalendar,
                    selectedDate: $calendarSelectedDate,
                    onConfirm: {
                        // 확인 버튼을 눌렀을 때만 ViewModel 날짜 업데이트
                        viewModel.selectedDate = calendarSelectedDate
                    }
                )
                .onAppear {
                    // 시트가 열릴 때 현재 설정된 날짜로 초기화 (취소 후 재진입 시 동기화)
                    calendarSelectedDate = viewModel.selectedDate ?? Date()
                }
            }
        }
    }
}
