//
//  EditScheduleView.swift
//  TAMINGO
//
//  Created by 김도연 on 2/4/26.
//

import SwiftUI

struct EditScheduleView: View {
    @State private var viewModel = EditScheduleViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var activeSheet: SheetType? = nil
    @State private var showDeleteAlert = false
    @State private var errorAlert = false
    
    let scheduleId: Int
    
    var onSave: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            ScheduleHeader(
                title: "일정 수정",
                onDismiss: { dismiss() }
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // 제목 입력 필드
                    ScheduleTitleInput(title: $viewModel.title)
                    
                    // 날짜 및 시간
                    ScheduleDateTime(
                        startTime: viewModel.startTime,
                        endTime: viewModel.endTime,
                        isTimeValid: viewModel.isTimeValid,
                        onDateTap: { activeSheet = .date },
                        onStartTimeTap: { activeSheet = .startTime },
                        onEndTimeTap: { activeSheet = .endTime }
                    )
                    
                    // 장소 수정
                    EditPlace(
                        placeName: viewModel.placeName,
                        myPlaces: viewModel.myPlaces,
                        onSelectPlace: { viewModel.selectPlace($0) },
                        onDeletePlace: { viewModel.removePlace() }
                    )
                    
                    // 할 일 수정
                    EditTodo(
                        linkedTodos: viewModel.linkedTodos,
                        candidateTodos: viewModel.candidateTodos,
                        isTodoExpanded: $viewModel.isTodoExpanded,
                        onToggleTodo: { todo in
                            viewModel.toggleTodoSelection(todo)
                        }
                    )
                    
                    // 카테고리 수정
                    EditCategory(
                        categoryName: viewModel.categoryName,
                        categories: viewModel.categories,
                        onSelectCategory: { viewModel.selectCategory($0) },
                        onDeleteCategory: { viewModel.removeCategory() }
                    )
                    
                    // 일정 반복 수정
                    ScheduleRepeatView(
                        repeatType: viewModel.repeatType,
                        isEndDated: $viewModel.isEndDated,
                        repeatEndDate: viewModel.repeatEndDate,
                        onRepeatTypeTap: { activeSheet = .repeatType },
                        onRepeatEndDateTap: { activeSheet = .repeatEndDate }
                    )
                    
                    // 메모 필드
                    ScheduleMemo(memo: $viewModel.memo)
                    
                    ScheduleDeleteButton() {
                        showDeleteAlert.toggle()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            
            // 하단 버튼 컴포넌트
            ScheduleBottomButtons(
                isSaveDisabled: viewModel.title.isEmpty || !viewModel.isTimeValid, saveTitle: "일정 수정",
                onCancel: { dismiss() },
                onSave: {
                    Task {
                        let success = await viewModel.editSchedule()
                        if success {
                            onSave?()
                            dismiss()
                        } else {
                            errorAlert.toggle()
                        }
                    }
                }
            )
        }
        .task {
            await viewModel.loadSchedule(id: scheduleId)
        }
        .sheet(item: $activeSheet) { type in
            ScheduleSheetContent(
                type: type,
                startTime: $viewModel.startTime,
                endTime: $viewModel.endTime,
                repeatType: $viewModel.repeatType,
                repeatEndDate: $viewModel.repeatEndDate
            )
            .presentationDetents([.height(240)])
            .presentationDragIndicator(.visible)
        }
        .alert("일정을 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                Task {
                    let success = await viewModel.deleteSchedule(id: scheduleId)
                    
                    if success {
                        onSave?()
                        dismiss()
                    }
                }
            }
        }
        .alert("알림", isPresented: $errorAlert) {
            Button("확인", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("일정 수정을 실패했어요.")
        }
    }
}

#Preview {
    EditScheduleView(scheduleId: 3)
}
