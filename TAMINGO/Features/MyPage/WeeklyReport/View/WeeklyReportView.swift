//
//  WeeklyReportView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/1/26.
//

import SwiftUI


struct WeeklyReportView: View {
    @State private var vm = WeeklyReportViewModel()

    let onBack: () -> Void

    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.horizontal, 32)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    WeeklyMetricSection(vm: vm)
                    
                    WeeklyActivitySection(activities: vm.safeActivities)
                    
                    WeeklyInsightSection(insights: vm.insightItems)
                    
                    WeeklyComparisonSection(metrics: vm.comparisonMetrics)
                    
                    
                    Spacer()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
            }
        }
        .padding(.vertical, 16)
        .navigationBarBackButtonHidden(true)
        .task {
            await vm.fetchReport()
        }
        .onChange(of: vm.selectedPeriod) {
            Task {
                await vm.fetchReport()
            }
        }

    }
    
    var header: some View {
        HStack(spacing: 14){
            Button(action: {
                onBack()
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

    var body: some View {
        
        let metrics = vm.weeklyMetrics
        
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
    let activities: [DailyActivity]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("요일별 활동")
                .font(.regular12)
                .foregroundStyle(.gray2)

            VStack(spacing: 8) {
                ForEach(activities, id: \.day) { activity in
                    WeeklyActivityRowView(
                        day: activity.day.displayName,
                        scheduleCount: activity.scheduleCount,
                        todoCount: activity.taskCount,
                        progress: Double(activity.activityRate) / 100.0,
                        resultText: "\(activity.activityRate)% 정시"
                    )
                }
            }
        }
        .padding(16)
        .cardStyle()
    }
}

struct WeeklyInsightSection: View {
    let insights: [WeeklyInsight]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Text(insightTitle)
                Spacer()
            }
            if insights.isEmpty{
                Text("인사이트가 없음")
                    .font(.regular12)
                    .foregroundStyle(.gray2)
            }else{
                ForEach(insights) { insight in
                    InsightCardView(
                        emoji: insight.emoji,
                        title: insight.title,
                        description: insight.description,
                        borderColor: insight.borderColor,
                        backgroundColor: insight.backgroundColor,
                        titleColor: insight.titleColor
                    )
                }
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
    NavigationStack {
        WeeklyReportView {
            print("back")
        }
    }
}

