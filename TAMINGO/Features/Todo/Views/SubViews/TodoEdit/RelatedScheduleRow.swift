//
//  RelatedScheduleRow.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//  Updated: Row Layout (Checkbox, Title, Location Tag)
//

import SwiftUI

struct RelatedScheduleRow: View {
    @Binding var schedule: TodoRelatedScheduleItem
    
    var body: some View {
        Button(action: {
            schedule.isSelected.toggle()
        }) {
            HStack(spacing: 12) {
                // MARK: - Checkbox (16x16, Radius 3.5)
                ZStack {
                    RoundedRectangle(cornerRadius: 3.5)
                        .stroke(Color.gray1, lineWidth: 1)
                        .frame(width: 16, height: 16)
                    
                    if schedule.isSelected {
                        Image(systemName: "checkmark.square.fill") // 디자인에 맞춰 이미지 변경 가능 (예: 커스텀 에셋)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.mainMint)
                            .background(Color.white)
                            .cornerRadius(3.5)
                    }
                }
                
                // MARK: - Title
                Text(schedule.title)
                    .font(.medium14)
                    .foregroundColor(.gray2) // 가이드: "팀플 미팅".color(.gray2)
                    .lineLimit(1)
                
                Spacer()
                
                // MARK: - Location Tag (Radius 10)
                if !schedule.location.isEmpty {
                    Text(schedule.location)
                        .font(.regular12)
                        .foregroundColor(.gray2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        // 높이를 텍스트에 맞춰 유동적으로 하거나, 고정이 필요하면 frame(height: 22) 등 사용
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray1, lineWidth: 1)
                        )
                }
                
            
            }
            .contentShape(Rectangle()) // 터치 영역 확장
        }
        .buttonStyle(.plain)
    }
}
