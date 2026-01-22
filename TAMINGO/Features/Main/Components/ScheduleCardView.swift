//
//  ScheduleCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct ScheduleCardView: View {
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

            if let remaining = schedule.remainingText {
                Text(remaining)
                    .font(.regular12)
                    .foregroundStyle(.gray2)
                    .layoutPriority(1)
            }
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray2, lineWidth: 1.5)
        }
    }
}
