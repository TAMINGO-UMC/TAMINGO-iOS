//
//  ScheduleBottomButtons.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

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
