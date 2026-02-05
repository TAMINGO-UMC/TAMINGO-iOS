//
//  WeeklyReportCardView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI

// mock 데이터
let weeklyMetricMocks: [WeeklyMetric] = [
    WeeklyMetric(
        title: "정시 도착률",
        value: "92%",
        subValue: "+5% 상승",
        iconName: "MyPage_icon_report01",
        textColor: .subBlue2,
        backgroundColor: .subBlue1
    ),
    WeeklyMetric(
        title: "할 일 완료율",
        value: "92%",
        subValue: "17/20개",
        iconName: "MyPage_icon_report02",
        textColor: .subPP2,
        backgroundColor: .subPP1
    ),
    WeeklyMetric(
        title: "생산성 점수",
        value: "87점",
        subValue: "우수",
        iconName: "MyPage_icon_report03",
        textColor: .subPink2,
        backgroundColor: .subPink1
    )
]


struct MainWeeklyMetricItemView : View {
    let metric: WeeklyMetric
    var body: some View {
        VStack(alignment:.leading, spacing:3){
            HStack(spacing:5.4){
                Image(metric.iconName)
                    .resizable()
                    .frame(width: 10, height: 10)
                Text(metric.title)
                    .font(.regular10)
                    .foregroundStyle(metric.textColor)
                Spacer()
            }
            Text(metric.value)
                .font(.semiBold16)
                .foregroundStyle(metric.textColor)
            Text(metric.subValue)
                .font(.regular10)
                .foregroundStyle(metric.textColor)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .frame(width: 95, height: 66, alignment: .center)
        .background(metric.backgroundColor)
        .cornerRadius(5)
    }
}

struct DetailWeeklyMetricItemView : View {
    let metric: WeeklyMetric
    var body: some View {
        VStack(alignment:.leading, spacing:7){
            HStack(){
                Image(metric.iconName)
                    .resizable()
                    .frame(width: 16.5, height: 16.5)
                Text(metric.title)
                    .font(.medium14)
                    .foregroundStyle(metric.textColor)
                Spacer()
            }
            Text(metric.value)
                .font(.medium24)
                .foregroundStyle(metric.textColor)
            Text(metric.subValue)
                .font(.medium14)
                .foregroundStyle(metric.textColor)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(metric.backgroundColor)
        .cornerRadius(5)
    }
}



#Preview {
    VStack{
        MainWeeklyMetricItemView(metric: weeklyMetricMocks[1])
            .padding()
        DetailWeeklyMetricItemView(metric: weeklyMetricMocks[1])
    }
}
