//
//  WeeklyReportView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/1/26.
//

import SwiftUI

struct WeeklyReportView: View {
    @State private var vm = WeeklyReportViewModel()
    
    let weeklyMetrics: [WeeklyMetric]
    let comparisonMetrics: [WeeklyComparisonMetric]
    
    var body: some View {
        VStack(alignment:.leading, spacing:0){
            header
                .padding(.horizontal, 16)
            ScrollView{
                VStack(alignment:.leading, spacing:16){
                    WeeklyMetricSection(vm: vm, metrics: weeklyMetrics)
                    WeeklyActivitySection()
                    WeeklyInsightSection()
                    WeeklyComparisonSection(metrics: comparisonMetrics)
                }
                .padding(16)
            }
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
    }
    
}
struct WeeklyMetricSection: View {
    var vm: WeeklyReportViewModel
    let metrics: [WeeklyMetric]

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 12) {
                PeriodFilterView(vm: vm)
                    .frame(height: 30)
                if metrics.count >= 2 {
                    HStack(spacing: 12) {
                        DetailWeeklyMetricItemView(metric: metrics[0])
                        DetailWeeklyMetricItemView(metric: metrics[1])
                    }
                }
                if metrics.count >= 3 {
                    DetailWeeklyMetricItemView(metric: metrics[2])
                }
            }
            .padding(16)
            .cardStyle()
            
            if vm.isPeriodListVisible {
                SelectList(
                    items: vm.periodOptions,
                    selected: vm.selectedPeriod,
                    width: 134,
                    isDisabled: { _ in false },
                    onSelect: {
                        vm.selectedPeriod = $0
                        vm.isPeriodListVisible = false
                    },
                    titleProvider: vm.title(for:)
                )
                .offset(x: 190, y: 50)
                .zIndex(100)
            }
        }
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
