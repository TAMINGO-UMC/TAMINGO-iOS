//
//  ScheduleCard.swift
//  TAMINGO
//
//  Created by 김도연 on 1/18/26.
//

import SwiftUI

struct ScheduleCard: View {
    let schedule: ScheduleListDTO
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Capsule()
                .fill(color)
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("\(schedule.startTime.toTimeStr(format: "HH:mm"))  \(schedule.title)")
                        .font(.medium14)
                        .foregroundStyle(.black00)
                    
                    if let cat = schedule.category {
                        Text(cat)
                            .font(.medium12)
                            .foregroundStyle(color)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(color.opacity(0.15))
                            )
                    } else {
                        Text("없음")
                            .font(.medium12)
                            .foregroundStyle(.gray)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.gray.opacity(0.15))
                            )
                    }
                }
                
                if let place = schedule.placeName {
                    Text("\(schedule.endTime.toTimeStr(format: "HH:mm"))  \(place)")
                        .font(.medium12)
                        .foregroundStyle(.gray2)
                } else {
                    Text("\(schedule.endTime.toTimeStr(format: "HH:mm"))  장소 없음")
                        .font(.medium12)
                        .foregroundStyle(.gray2)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.08), radius: 4.75, x: 2, y: 3)
                    .frame(height: 60)
            )
        }
        .frame(height: 60)
    }
}
