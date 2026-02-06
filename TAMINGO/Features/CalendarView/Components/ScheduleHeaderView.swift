//
//  ScheduleHeaderView.swift
//  TAMINGO
//
//  Created by 김도연 on 2/2/26.
//

import SwiftUI

// MARK: - Header View
struct ScheduleHeaderView: View {
    var title: String
    var onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.semiBold18)
                .foregroundStyle(.black)
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

// MARK: - Bottom Action Buttons
struct ScheduleBottomButtons: View {
    var isSaveDisabled: Bool
    var onCancel: () -> Void
    var onSave: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // 취소 버튼
            Button(action: onCancel) {
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
            
            // 저장 버튼
            Button(action: onSave) {
                ZStack {
                    Text("일정 추가")
                        .font(.semiBold14)
                        .foregroundStyle(isSaveDisabled ? .gray2 : .white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isSaveDisabled ? .gray1 : .mainMint)
                .cornerRadius(8)
            }
            .disabled(isSaveDisabled)
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
}

// MARK: - Recommendation Overlay (AI 장소 추가 팝업)
struct RecommendationOverlayView: View {
    let placeName: String
    @Binding var isAdded: Bool
    var onAddAction: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                if isAdded {
                    Text("\"\(placeName)\" 을(를) 추가했습니다!")
                        .font(.semiBold12)
                        .foregroundStyle(.white)
                    Text("설정에서 이름을 바꿀 수 있어요.")
                        .font(.regular12)
                        .foregroundStyle(Color.gray1)
                } else {
                    Text("'\(placeName)' 을(를) 자주 가시네요! \n자주가는 장소에 추가할까요 ?")
                        .font(.regular12)
                        .foregroundStyle(.white)
                }
            }
            
            Spacer()
            
            Button {
                if !isAdded {
                    withAnimation {
                        onAddAction()
                        isAdded = true
                    }
                }
            } label: {
                Text(isAdded ? "추가 완료" : "추가")
                    .font(.semiBold12)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.mainPink))
            }
            .disabled(isAdded)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.8)))
        .padding(.horizontal, 20)
    }
}
