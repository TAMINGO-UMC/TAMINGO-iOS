//
//  AddScheduleView.swift
//  TAMINGO
//
//  Created by 김도연 on 1/23/26.
//

import SwiftUI

struct AddScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = AddScheduleViewModel()
    
    // TODO: ViewModel에 연동, 더 작은 View파일로 나눌 예정
    @State private var memoInput: String = ""
    @State private var isTodoExpanded: Bool = true
    @State private var activeSheet: SheetType? = nil
    
    var onSave: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    titleSection
                    
                    dateTimeSection
                    
                    placeSection
                    
                    todoConnectionSection
                    
                    categorySection
                    
                    repeatSection
                    
                    memoSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            bottomButtonSection
        }
        // MARK: - Sheet (날짜/시간 선택기)
        .sheet(item: $activeSheet) { type in
            Group {
                switch type {
                case .date:
                    DatePicker("", selection: $viewModel.startTime, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .padding()
                        .onChange(of: viewModel.startTime) { _, newValue in
                            // TODO: 날짜 변경 시 종료일 보정 로직 추가 -> ViewModel에 넘길 수도
                        }
                    
                case .startTime:
                    DatePicker("", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                    
                case .endTime:
                    DatePicker("", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                case .repeatType:
                    Picker("", selection: $viewModel.repeatType) {
                        ForEach(RepeatType.allCases, id: \.self) { type in
                            Text(type.title)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                }
            }
            .presentationDetents([.height(240)])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Subviews & Sections
private extension AddScheduleView {
    
    // 헤더 뷰
    var headerView: some View {
        HStack {
            Text("새 일정 추가")
                .font(.semiBold18)
                .foregroundStyle(.black)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // 제목 섹션
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "제목", isRequired: true)
            
            TextField("일정 제목을 입력하세요", text: $viewModel.titleInput)
                .font(.medium12)
                .padding()
                .background(.gray0)
                .cornerRadius(8)
        }
    }
    
    // MARK: - 날짜 및 시간 섹션
    var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                sectionHeader(title: "날짜", isRequired: true)
                
                ScheduleOptionRow(
                    title: viewModel.startTime.toString(format: "yyyy.MM.dd"),
                    image: "calendar"
                ) {
                    activeSheet = .date
                }
            }
            
            HStack(spacing: 12) {
                // 시작 시간
                VStack(alignment: .leading, spacing: 10) {
                    sectionHeader(title: "시작 시간", isRequired: true)
                    ScheduleOptionRow(
                        title: viewModel.startTime.toString(format: "a h:mm"),
                        image: "stopwatch"
                    ) {
                        activeSheet = .startTime
                    }
                }
                // TODO: 종료 시간은 항상 시작 시간보다 이후인 조건 적용
                // 종료 시간
                VStack(alignment: .leading, spacing: 10) {
                    sectionHeader(title: "종료 시간", isRequired: true)
                    ScheduleOptionRow(
                        title: viewModel.endTime.toString(format: "a h:mm"),
                        image: "stopwatch"
                    ) {
                        activeSheet = .endTime
                    }
                }
            }
        }
    }
    
    // MARK: - AI 추론 파트 -> API response 맞춰서 ViewModel단에서 추후 수정 예정
    // 장소 섹션 (AI)
    var placeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                sectionHeader(title: "장소", isRequired: false)
                aiBadge
            }
            
            if viewModel.isAnalyzing {
                loadingRow(text: "장소 추론중 ...")
            } else {
                if viewModel.titleInput.isEmpty {
                    Text("제목 입력 시 AI가 장소를 추론합니다")
                        .font(.medium12)
                        .foregroundStyle(.gray)
                        .padding(.top, 4)
                } else {
                    
                }
            }
        }
    }
    
    // 할 일 연결 섹션 (AI)
    var todoConnectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                sectionHeader(title: "할 일 연결", isRequired: false)
                aiBadge
            }
            
            if viewModel.isAnalyzing {
                loadingRow(text: "할 일 추론중 ...")
            } else if viewModel.titleInput.isEmpty {
                Text("제목 입력 시 AI가 연관 할 일을 추론합니다")
                    .font(.medium12)
                    .foregroundStyle(.gray)
                    .padding(.top, 4)
            } else {
                // 추론 완료 후 보여질 카드
                // TODO: - 일정Card 제작 후 ForEach 반복 예정
                VStack(spacing: 0) {
                    Text("이 일정과 관련된 할 일을 선택하세요")
                        .font(.medium12)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundStyle(Color.mainMint)
                            Text("도서 반납")
                                .font(.medium14)
                            Spacer()
                            Text("중앙도서관")
                                .font(.medium12)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.gray1, lineWidth: 1)
                                )
                        }
                        .foregroundStyle(.gray2)
                        
                        Divider()
                        
                        Button {
                            // TODO: 더보기 액션
                        } label: {
                            HStack {
                                Text("할 일 전체보기")
                                Image(systemName: "chevron.down")
                            }
                            .font(.medium12)
                            .foregroundStyle(.gray2)
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 4)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray1, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    // 카테고리 섹션 (AI)
    var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                sectionHeader(title: "카테고리", isRequired: false)
                aiBadge
            }
            
            if viewModel.isAnalyzing {
                loadingRow(text: "카테고리 추론중 ...")
            } else if viewModel.titleInput.isEmpty {
                Text("제목 입력 시 AI가 카테고리를 추론합니다")
                    .font(.medium12)
                    .foregroundStyle(.gray)
                    .padding(.top, 4)
            } else {
                HStack {
                    Text("학교")
                        .font(.medium12)
                    Spacer()
                    Button("수정") { }
                        .font(.medium12)
                        .foregroundStyle(Color.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray0)
                        .cornerRadius(6)
                }
            }
        }
    }
    
    // 반복 설정 섹션
    var repeatSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "반복 설정", isRequired: false)
            ScheduleOptionRow(
                title: viewModel.repeatType.title,
                image: "chevron.right"
            ) {
                activeSheet = .repeatType
            }
        }
    }
    
    // 메모 섹션
    var memoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "메모", isRequired: false)
            TextField("추가 메모를 입력하세요", text: $viewModel.memo, axis: .vertical)
                .font(.medium12)
                .padding(16)
                .frame(minHeight: 100, alignment: .top)
                .background(Color.gray0)
                .cornerRadius(8)
        }
    }
    
    // 하단 버튼 섹션
    var bottomButtonSection: some View {
        HStack(spacing: 12) {
            Button {
                dismiss()
            } label: {
                Text("취소")
                    .font(.semiBold14)
                    .foregroundStyle(.gray2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray1, lineWidth: 1)
                    )
            }
            
            Button {
                viewModel.saveSchedule {
                    onSave?()
                    dismiss()
                }
            } label: {
                ZStack {
                    if viewModel.isSaving {
                        ProgressView().tint(.white)
                    } else {
                        Text("일정 추가")
                            .font(.semiBold14)
                            .foregroundStyle(viewModel.titleInput.isEmpty ? .gray2 : .white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(viewModel.titleInput.isEmpty ? .gray1 : .mainMint)
                .cornerRadius(8)
            }
            .disabled(viewModel.titleInput.isEmpty)
        }
        .padding(20)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.gray0),
            alignment: .top
        )
    }
    
    // MARK: - Components
    
    func sectionHeader(title: String, isRequired: Bool) -> some View {
        HStack(spacing: 2) {
            Text(title)
                .font(.medium14)
            if isRequired {
                Text("*")
                    .font(.medium14)
                    .foregroundStyle(.mainMint)
            }
        }
    }
    
    var aiBadge: some View {
        Text("AI 추론")
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(Color.mainMint)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.mainMint.opacity(0.1))
            .cornerRadius(4)
    }
    
    func loadingRow(text: String) -> some View {
        HStack(spacing: 10) {
            ProgressView()
                .tint(.mainMint)
                .scaleEffect(0.8)
            Text(text)
                .font(.medium12)
                .foregroundStyle(.black)
        }
        .padding(.top, 4)
    }
}

#Preview {
    AddScheduleView()
}
