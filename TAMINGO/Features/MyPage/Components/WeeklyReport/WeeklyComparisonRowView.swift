//
//  WeeklyComparisonRowView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//

import SwiftUI

struct WeeklyComparisonRowView: View {
    let title: String
    let previousValue: Int   // 78
    let currentValue: Int    // 85
    let diffValue: Int       // 7

    var body: some View {
        HStack {
            Text(title)
                .font(.regular12)
                .foregroundStyle(.black00)

            Spacer()

            HStack(spacing: 8) {
                Text("\(previousValue)% →")
                    .foregroundStyle(.gray1)

                Text("\(currentValue)%")
                    .foregroundStyle(.mainMint)

                Text(diffText)
                    .foregroundStyle(diffColor)
            }
            .font(.regular12)
        }
    }

    // MARK: - Computed Properties
    private var diffText: String {
        diffValue >= 0 ? "↑\(diffValue)%" : "↓\(abs(diffValue))%"
    }

    private var diffColor: Color {
        diffValue >= 0 ? .subBlue2 : .red
    }
}


#Preview {
    VStack(spacing: 12) {
        WeeklyComparisonRowView(
            title: "할일 완료율",
            previousValue: 78,
            currentValue: 85,
            diffValue: 7
        )

        WeeklyComparisonRowView(
            title: "정시 도착률",
            previousValue: 92,
            currentValue: 88,
            diffValue: -4
        )
    }
    .padding()
}
