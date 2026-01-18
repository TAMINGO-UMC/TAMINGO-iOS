//
//  ScheduleCard.swift
//  TAMINGO
//
//  Created by 김도연 on 1/18/26.
//

import SwiftUI

struct ScheduleCard: View {
    let title: String
    let place: String
    let category: String
    let startTime: String
    let endTime: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Capsule()
                .fill(color)
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("\(startTime)  \(title)")
                        .font(.medium14)
                        .foregroundStyle(.black00)
                    
                    Text(category)
                        .font(.medium12)
                        .foregroundStyle(color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(color.opacity(0.15))
                        )
                }
                Text("\(endTime)  \(place)")
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
    ScheduleCard(title: "강의", place: "공학관", category: "학교", startTime: "09:40", endTime: "10:40", color: .mainPink)
    ScheduleCard(title: "강의", place: "공학관", category: "학교", startTime: "09:40", endTime: "10:40", color: .blue)
    ScheduleCard(title: "강의", place: "공학관", category: "학교", startTime: "09:40", endTime: "10:40", color: .mainMint)
}
