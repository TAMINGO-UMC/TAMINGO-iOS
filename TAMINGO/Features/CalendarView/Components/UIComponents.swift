//
//  UIComponents.swift
//  TAMINGO
//
//  Created by 김도연 on 1/31/26.
//

import SwiftUI

extension AddScheduleView {
    // MARK: - Header & Footer
    var headerView: some View {
        HStack {
            Text("새 일정 추가")
                .font(.semiBold18)
                .foregroundStyle(.black)
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
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
                Task {
                    _ = await viewModel.createSchedule()
                    dismiss()
                }
            } label: {
                ZStack {
                    Text("일정 추가")
                        .font(.semiBold14)
                        .foregroundStyle((viewModel.title.isEmpty || !viewModel.isTimeValid) ? .gray2 : .white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background((viewModel.title.isEmpty || !viewModel.isTimeValid) ? .gray1 : .mainMint)
                .cornerRadius(8)
            }
            .disabled(viewModel.title.isEmpty || !viewModel.isTimeValid)
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
    
    // MARK: - Overlay (Recommendation)
    var recommendationOverlay: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                if isFavoriteAdded {
                    Text("\"\(viewModel.placeName)\" 을(를) 추가했습니다!")
                        .font(.semiBold12)
                        .foregroundStyle(.white)
                    Text("설정에서 이름을 바꿀 수 있어요.")
                        .font(.regular12)
                        .foregroundStyle(Color.gray1)
                } else {
                    Text("'\(viewModel.placeName)' 을(를) 자주 가시네요! \n자주가는 장소에 추가할까요 ?")
                        .font(.regular12)
                        .foregroundStyle(.white)
                }
            }
            
            Spacer()
            
            Button {
                if !isFavoriteAdded {
                    withAnimation {
                        viewModel.addFavoritePlace()
                        isFavoriteAdded = true
                    }
                }
            } label: {
                Text(isFavoriteAdded ? "추가 완료" : "추가")
                    .font(.semiBold12)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.mainPink))
            }
            .disabled(isFavoriteAdded)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.8)))
        .padding(.horizontal, 20)
    }
    
    // MARK: - Sheet Content
    @ViewBuilder
    func sheetContent(for type: SheetType) -> some View {
        Group {
            switch type {
            case .date:
                DatePicker("", selection: $viewModel.startTime, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
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
                        Text(type.title).tag(type)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .padding()
            case .repeatEndDate:
                DatePicker("", selection: $viewModel.repeatEndDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
        }
    }
    
    // MARK: - Small Helpers
    func sectionHeader(title: String, isRequired: Bool) -> some View {
        HStack(spacing: 2) {
            Text(title).font(.medium14)
            if isRequired {
                Text("*").font(.medium14).foregroundStyle(Color.mainMint)
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
            ProgressView().tint(Color.mainMint).scaleEffect(0.8)
            Text(text).font(.medium12).foregroundStyle(.black)
        }
        .padding(.top, 4)
    }
    
    func aiGuideText(text: String) -> some View {
        Text(text)
            .font(.medium12)
            .foregroundStyle(.gray)
            .padding(.top, 4)
    }
    
    func selectedItemRow(title: String, onEdit: @escaping () -> Void) -> some View {
        HStack {
            Text(title).font(.medium12)
            Spacer()
            Button("수정") { onEdit() }
                .font(.medium12)
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray0)
                .cornerRadius(6)
        }
    }
    
    func expandCollapseButton(isExpanded: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(isExpanded ? "추론된 할 일만 보기" : "할 일 전체보기")
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .font(.medium12)
            .foregroundStyle(Color.gray2)
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
            .padding(.bottom, 4)
        }
    }
}
