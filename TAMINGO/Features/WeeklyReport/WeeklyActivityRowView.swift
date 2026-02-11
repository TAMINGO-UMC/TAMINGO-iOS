//
//  WeeklyActivityRowView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//

import SwiftUI

let weeklyComparisonMocks: [WeeklyComparisonMetric] = [
    WeeklyComparisonMetric(
        title: "정시 도착률",
        previousValue: 87,
        currentValue: 92,
        diffValue: 5
    ),
    WeeklyComparisonMetric(
        title: "할일 완료율",
        previousValue: 78,
        currentValue: 85,
        diffValue: 7
    )
]


struct WeeklyActivityRowView: View {
    let day: String              // 월, 화, 수 …
    let scheduleCount: Int       // 일정
    let todoCount: Int           // 할일
    let progress: Double         // 0.83
    let resultText: String       // "83% 정시"

    var body: some View {
        HStack(spacing: 12) {

            Text(day)
                .font(.regular12)
                .foregroundStyle(.black00)
                .frame(width: 32, height: 32)
                .background(.subMint)
                .cornerRadius(5)
                .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.mainMint, lineWidth: 1)
                    )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("일정 \(scheduleCount)개 · 할일 \(todoCount)개")
                        .font(.regular12)
                        .foregroundStyle(.black00)

                    Spacer()

                    Text(resultText)
                        .font(.medium14)
                        .foregroundStyle(.mainMint)
                }
                ReportProgressBar(value: progress)
            }
        }
    }
}

struct ReportProgressBar: View {
    let value: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(red: 245/255, green: 245/255, blue: 245/255))

                Capsule()
                    .fill(.mainMint)
                    .frame(width: geo.size.width * value)
            }
        }
        .frame(height: 6)
    }
}


#Preview {
    VStack(spacing: 12) {
        WeeklyActivityRowView(
            day: "월",
            scheduleCount: 5,
            todoCount: 3,
            progress: 0.83,
            resultText: "83% 정시"
        )
    }
    .padding()
}
