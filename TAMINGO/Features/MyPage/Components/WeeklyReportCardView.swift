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


struct WeeklyReportSection: View {
    let metrics: [WeeklyMetric]

    var body: some View {
        Button(action:{
            
        }, label:{
            VStack(alignment: .leading, spacing: 12) {
                header

                HStack {
                    ForEach(Array(metrics.enumerated()), id: \.element.id) { index, metric in
                        WeeklyMetricItemView(metric: metric)

                        if index != metrics.count - 1 {
                            Spacer(minLength: 0)
                        }
                    }
                }

            }
            .padding(16)
            .cardStyle()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.mainMint, lineWidth: 1)
            )
        })
    }
    
    var header: some View {
        HStack{
            Image("MyPage_graph")
                .resizable()
                .scaledToFit()
                .frame(width: 16)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray1, lineWidth: 1)
                )

            
            Text("주간 리포트")
                .font(.medium14)
                .foregroundStyle(.black00)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 5, height: 10)
                .foregroundStyle(.black00)
        }

    }
}

struct WeeklyMetricItemView : View {
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



#Preview {
    WeeklyReportSection(metrics: weeklyMetricMocks)
        .padding()
}
