//
//  RelatedScheduleRow.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//

import SwiftUI

struct RelatedScheduleRow: View {
    @Binding var schedule: TodoRelatedScheduleItem
    
    var body: some View {
        Button(action: {
            schedule.isSelected.toggle()
        }) {
            HStack(spacing: 12) {
                // 체크박스
                Image(systemName: schedule.isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(schedule.isSelected ? .mainMint : .gray2)
                
                // 일정 정보
                VStack(alignment: .leading, spacing: 4) {
                    Text(schedule.title)
                        .font(.medium14)
                        .foregroundColor(.black)
                    
                    if !schedule.location.isEmpty {
                        Text(schedule.location)
                            .font(.regular12)
                            .foregroundColor(.gray2)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        RelatedScheduleRow(
            schedule: .constant(
                TodoRelatedScheduleItem(
                    title: "회의",
                    location: "광운대학교",
                    isSelected: true,
                    scheduleId: 1
                )
            )
        )
        
        RelatedScheduleRow(
            schedule: .constant(
                TodoRelatedScheduleItem(
                    title: "점심 약속",
                    location: "강남역",
                    isSelected: false,
                    scheduleId: 2
                )
            )
        )
    }
    .padding()
}
