//
//  AddScheduleView.swift
//  TAMINGO
//
//  Created by 김도연 on 1/23/26.
//

import SwiftUI

struct AddScheduleView: View {
    @State var viewModel = AddScheduleViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var activeSheet: SheetType? = nil
    @State var isEndDated: Bool = true
    @State var isFavoriteAdded: Bool = false
    
    var onSave: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더 컴포넌트 사용
            ScheduleHeaderView(
                title: "새 일정 추가",
                onDismiss: { dismiss() }
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // 제목 입력 필드
                    ScheduleTitleInputView(title: $viewModel.title)
                    
                    // 날짜 및 시간
                    ScheduleDateTimeView(
                        startTime: viewModel.startTime,
                        endTime: viewModel.endTime,
                        isTimeValid: viewModel.isTimeValid,
                        onDateTap: { activeSheet = .date },
                        onStartTimeTap: { activeSheet = .startTime },
                        onEndTimeTap: { activeSheet = .endTime }
                    )
                    
                    // AI 장소
                    SchedulePlaceView(
                        isLoading: viewModel.isLoading,
                        titleInput: viewModel.title,
                        placeName: viewModel.placeName,
                        myPlaces: viewModel.myPlaces,
                        onSelectPlace: { viewModel.selectPlace($0) },
                        onResetFavoriteRecommendation: { viewModel.isFavoriteRecommendation = false }
                    )
                    
                    // AI 할 일 연결
                    ScheduleTodoConnectionView(
                        isLoading: viewModel.isLoading,
                        titleInput: viewModel.title,
                        linkedTodoIds: viewModel.linkedTodoIds,
                        selectedTodoObjects: viewModel.selectedTodoObjects,
                        nearbyTodos: viewModel.nearbyTodos,
                        candidateTodos: viewModel.candidateTodos,
                        isTodoExpanded: $viewModel.isTodoExpanded,
                        onToggleTodo: { viewModel.toggleTodoSelection($0) },
                        onClearTodos: { viewModel.linkedTodoIds.removeAll() }
                    )
                    
                    // AI 카테고리
                    ScheduleCategoryView(
                        isLoading: viewModel.isLoading,
                        titleInput: viewModel.title,
                        categoryName: viewModel.categoryName,
                        categories: viewModel.categories,
                        onSelectCategory: { viewModel.selectCategory($0) }
                    )
                    
                    // 일정 반복 설정
                    ScheduleRepeatView(
                        repeatType: viewModel.repeatType,
                        isEndDated: $isEndDated,
                        repeatEndDate: viewModel.repeatEndDate,
                        onRepeatTypeTap: { activeSheet = .repeatType },
                        onRepeatEndDateTap: { activeSheet = .repeatEndDate }
                    )
                    .task(id: isEndDated) {
                        viewModel.updateRepeatEndDate(isEnabled: isEndDated)
                    }
                    
                    // 메모 필드
                    ScheduleMemoView(memo: $viewModel.memo)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            
            // 하단 버튼 컴포넌트로 변경
            ScheduleBottomButtons(
                isSaveDisabled: viewModel.title.isEmpty || !viewModel.isTimeValid,
                onCancel: { dismiss() },
                onSave: {
                    Task {
                        let success = await viewModel.createSchedule()
                        if success {
                            onSave?()
                            dismiss()
                        } else {
                            //TODO: 저장 실패 시 알림
                        }
                    }
                }
            )
        }
        .overlay(alignment: .bottom) {
            // 오버레이 컴포넌트 사용
            if viewModel.isFavoriteRecommendation {
                RecommendationOverlayView(
                    placeName: viewModel.placeName,
                    isAdded: $isFavoriteAdded,
                    onAddAction: { viewModel.addFavoritePlace() }
                )
                .padding(.bottom, 100)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .sheet(item: $activeSheet) { type in
            // 시트 콘텐츠 컴포넌트 사용
            ScheduleSheetContentView(
                type: type,
                startTime: $viewModel.startTime,
                endTime: $viewModel.endTime,
                repeatType: $viewModel.repeatType,
                repeatEndDate: $viewModel.repeatEndDate
            )
            .presentationDetents([.height(240)])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    AddScheduleView()
}
