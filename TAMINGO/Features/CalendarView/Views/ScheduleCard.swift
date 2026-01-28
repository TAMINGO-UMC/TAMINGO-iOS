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
                    Text("\(schedule.startTimeString)  \(schedule.title)")
                        .font(.medium14)
                        .foregroundStyle(.black00)
                    
                    Text(schedule.category.title)
                        .font(.medium12)
                        .foregroundStyle(schedule.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(schedule.color.opacity(0.15))
                        )
                }
                Text("\(schedule.endTimeString)  \(schedule.place)")
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
