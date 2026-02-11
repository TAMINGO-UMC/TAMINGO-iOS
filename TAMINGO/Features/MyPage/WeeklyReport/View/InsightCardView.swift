//
//  InsightCardView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//

import SwiftUI

let weeklyInsightMocks: [WeeklyInsight] = [
    WeeklyInsight(
        title: "🎉 우수한 시간 관리",
        description: "이번 주 정시 도착률이 지난 주 대비 5% 상승했습니다",
        borderColor: .green,
        backgroundColor: Color.green.opacity(0.1),
        titleColor: .green
    ),
    WeeklyInsight(
        title: "⚠️ 화요일 주의",
        description: "화요일에 지각이 자주 발생합니다.\n출발 시간을 10분 앞당겨보세요",
        borderColor: .yellow,
        backgroundColor: Color.yellow.opacity(0.15),
        titleColor: .orange
    ),
    WeeklyInsight(
        title: "📊 가장 효율적인 요일",
        description: "목요일에 할일 완료율이 가장 높습니다 (100%)",
        borderColor: .blue,
        backgroundColor: Color.blue.opacity(0.1),
        titleColor: .blue
    )
]

struct InsightCardView: View {
    let title: String
    let description: String

    let borderColor: Color
    let backgroundColor: Color
    let titleColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.regular12)
                .foregroundStyle(titleColor)

            Text(description)
                .font(.regular12)
                .foregroundStyle(.black00)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(10)
    }
}


#Preview {
    VStack(spacing: 16) {
        InsightCardView(
            title: "🎉 우수한 시간 관리",
            description: "이번 주 정시 도착률이 지난 주 대비 5% 상승했습니다",
            borderColor: .green,
            backgroundColor: Color.green.opacity(0.1),
            titleColor: .green
        )

        InsightCardView(
            title: "⚠️ 화요일 주의",
            description: "화요일에 지각이 자주 발생합니다.\n출발 시간을 10분 앞당겨보세요",
            borderColor: .yellow,
            backgroundColor: Color.yellow.opacity(0.15),
            titleColor: .orange
        )

        InsightCardView(
            title: "📊 가장 효율적인 요일",
            description: "목요일에 할일 완료율이 가장 높습니다 (100%)",
            borderColor: .blue,
            backgroundColor: Color.blue.opacity(0.1),
            titleColor: .blue
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
