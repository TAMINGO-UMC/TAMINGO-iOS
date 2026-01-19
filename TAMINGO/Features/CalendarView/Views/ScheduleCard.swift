//
//  ScheduleCard.swift
//  TAMINGO
//
//  Created by 김도연 on 1/18/26.
//

import SwiftUI

struct ScheduleCard: View {
    let schedule: ScheduleItem
    
    var body: some View {
        HStack(spacing: 10) {
            Capsule()
                .fill(schedule.color)
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("\(schedule.startTime)  \(schedule.title)")
                        .font(.medium14)
                        .foregroundStyle(.black00)
                    
                    Text(schedule.category)
                        .font(.medium12)
                        .foregroundStyle(schedule.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(schedule.color.opacity(0.15))
                        )
                }
                Text("\(schedule.endTime)  \(schedule.place)")
                    .font(.medium12)
                    .foregroundStyle(.gray2)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.08), radius: 4.75, x: 2, y: 3)
            )
        }
        .frame(height: 60)
    }
}

#Preview {
    ScheduleCard(schedule: ScheduleItem(id: 1, title: "강의", place: "공학관", category: "학교", startTime: "09:40", endTime: "10:40", color: .mainPink))
    ScheduleCard(schedule: ScheduleItem(id: 2, title: "강의", place: "공학관", category: "학교", startTime: "09:40", endTime: "10:40", color: .blue))
    ScheduleCard(schedule: ScheduleItem(id: 3, title: "강의", place: "공학관", category: "학교", startTime: "09:40", endTime: "10:40", color: .mainMint))
}
