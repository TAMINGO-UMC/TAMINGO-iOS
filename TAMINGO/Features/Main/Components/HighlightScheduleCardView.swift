//
//  HighlightScheduleCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct HighlightScheduleCardView: View {
    let schedule: Schedule
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(schedule.time) \(schedule.title)")
                    .font(.medium14)
                    .foregroundStyle(.black00)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(schedule.location)
                    .font(.regular12)
                    .foregroundStyle(.gray2)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Text("다음 일정")
                    .font(.medium13)
                    .foregroundStyle(.mainMint)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 6)
                    .background{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.subMint)
                    }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray2)
            }
            .layoutPriority(1)
        }
        .padding(16)
        .background{
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.mainMint, lineWidth: 1.5)
        }
    }
}
