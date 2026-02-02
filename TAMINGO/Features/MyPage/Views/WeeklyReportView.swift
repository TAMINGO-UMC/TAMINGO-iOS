//
//  WeeklyReportView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/1/26.
//

import SwiftUI

struct WeeklyReportView: View {
    let weeklyMetrics: [WeeklyMetric]
    let comparisonMetrics: [WeeklyComparisonMetric]
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading, spacing:16){
                header
                WeeklyMetricSection(metrics: weeklyMetrics)
                WeeklyActivitySection()
                WeeklyInsightSection()
                WeeklyComparisonSection(metrics: comparisonMetrics)
            }
            .padding(.horizontal, 16)
        }
    }
    
    var header: some View {
        HStack(spacing: 14){
            Button(action: {
                
            }, label: {
                Image("Previous_Chevron")
                    .resizable()
                    .frame(width: 5, height: 10)
            })
            
            Text("주간 리포트")
                .font(.semiBold16)
                .foregroundStyle(.black00)
        }
        .padding(.horizontal, 7)
    }
}
struct WeeklyMetricSection: View {
    let metrics: [WeeklyMetric]

    var body: some View {
        VStack(spacing: 12) {
            PeriodFilterView()
                .frame(height: 30)
            HStack(spacing: 12) {
                DetailWeeklyMetricItemView(metric: metrics[0])
                DetailWeeklyMetricItemView(metric: metrics[1])
            }

            DetailWeeklyMetricItemView(metric: metrics[2])
        }
        .padding(16)
        .cardStyle()
    }
}


struct WeeklyActivitySection: View {
    let days = ["월", "화", "수", "목", "금", "토", "일"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("요일별 활동")
                .font(.regular12)
                .foregroundStyle(.gray2)

            VStack(spacing: 8) {
                ForEach(days, id: \.self) { day in
                    WeeklyActivityRowView(
                        day: day,
                        scheduleCount: 5,
                        todoCount: 3,
                        progress: 0.83,
                        resultText: "83% 정시"
                    )
                }
            }
        }
        .padding(16)
        .cardStyle()
    }
}

struct WeeklyInsightSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(insightTitle)
            ForEach(weeklyInsightMocks) { insight in
                InsightCardView(
                    title: insight.title,
                    description: insight.description,
                    borderColor: insight.borderColor,
                    backgroundColor: insight.backgroundColor,
                    titleColor: insight.titleColor
                )
            }
        }
        .padding(16)
        .cardStyle()
    }
    
    var insightTitle: AttributedString {
        var first = AttributedString("이번 주")
        first.foregroundColor = .mainMint
        first.font = .medium12

        var second = AttributedString(" 인사이트")
        second.foregroundColor = .gray2
        second.font = .regular12

        return first + second
    }
}

struct WeeklyComparisonSection: View {
    let metrics: [WeeklyComparisonMetric]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("주간 비교")
                .font(.regular12)
                .foregroundStyle(.gray2)
            
            ForEach(metrics) { metric in
                WeeklyComparisonRowView(
                    title: metric.title,
                    previousValue: metric.previousValue,
                    currentValue: metric.currentValue,
                    diffValue: metric.diffValue
                )
            }
        }
        .padding(16)
        .cardStyle()
    }
}


#Preview {
    WeeklyReportView(weeklyMetrics: weeklyMetricMocks, comparisonMetrics:weeklyComparisonMocks )
        .padding()
}
