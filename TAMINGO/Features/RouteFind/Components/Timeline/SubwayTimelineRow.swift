//
//  SubwayTimelineRow.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct SubwayTimelineRow: View {

    let leg: RouteLegModel
    let isFirst: Bool
    let isLast: Bool

    @State private var isExpanded = false

    private var lineColor: Color {
        Color(hex: leg.routeColor ?? "#999999")
    }

    private var badgeText: String {
        leg.routeName?.subwayBadgeText() ?? "?"
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {

            TimelineVerticalLineView(
                node: .subway(
                    lineText: badgeText,
                    color: lineColor
                ),
                above: .solid(lineColor),
                below: .solid(lineColor)
            )

            VStack(alignment: .leading, spacing: 10) {

                // 상단
                HStack(spacing: 10) {
                    Text(leg.startName ?? "")
                        .font(.semiBold14)

                    Text(leg.routeName ?? "")
                        .font(.regular12)
                        .foregroundStyle(.gray2)
                }

                // 중단
                HStack(spacing: 10) {
                    Text(subwayDirectionText() ?? "")
                        .font(.regular10)
                        .foregroundStyle(.gray2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.gray1.opacity(0.15))
                        )

                    Text("\(leg.endName ?? "") (\(directionSuffix()))")
                        .font(.semiBold14)

                    Text("\(leg.sectionTime)분")
                        .font(.medium14)
                        .foregroundStyle(.gray2)
                }

                // 하단 dropdown
                ExpandStationsView(
                    count: leg.stationCount,
                    time: leg.sectionTime,
                    stations: leg.stations
                )
                
                Text(leg.endName ?? "")
                    .font(.semiBold14)
            }
            .padding(.vertical, 20)

            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func grayPill(_ text: String) -> some View {
        Text(text)
            .font(.regular12)
            .foregroundStyle(.gray2)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray1.opacity(0.25))
            )
    }

    private func extractLineText(from routeName: String?) -> String? {
        // "수도권 2호선" -> "2호선" / "수도권 3호선" -> "3호선"
        guard let routeName else { return nil }
        if let range = routeName.range(of: "호선") {
            // 앞쪽 숫자 포함하도록 뒤에서 2~3글자 정도 추출 시도
            let prefix = routeName[..<range.upperBound]
            // 마지막 단어(예: "2호선") 반환
            let last = prefix.split(separator: " ").last.map(String.init)
            return last
        }
        return routeName
    }

    private func subwayDirectionText() -> String? {
        // API에 방향 필드가 없어서 임시로 “방면”
        // 나중에 direction이 오면 교체
        return "방면"
    }

    private func directionSuffix() -> String {
        // (데이터 생기면 교체)
        return "내선행"
    }
}

#Preview("RouteFind – Full Preview") {
    let route = RouteResultModel.preview

    ScrollView {
        VStack(spacing: 0) {

            RouteSummaryHeaderView(route: route)

            RouteInputCardView(
                            route: route,
                            wayPoints: route.wayPoints.map { $0.name }
                        )
            .padding(.bottom, 12)

            RouteTimelineView(route: route)
        }
    }
}
