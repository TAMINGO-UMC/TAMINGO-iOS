//
//  RouteTimelineView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct RouteTimelineView: View {
    
    let route: RouteResultModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 시작
            TimelineStartRow(
                startPlaceName: route.startPlaceName,
                isFirst: true
            )
            
            // legs 자동 렌더링
            ForEach(route.legs.indices, id: \.self) { idx in
                
                let leg = route.legs[idx]
                let isFirst = idx == 0
                let isLast = idx == route.legs.count - 1
                
                switch leg.mode {
                    
                case .walk:
                    WalkTimelineRow(
                        text: leg.walkDescription ?? "도보 \(leg.distance)m (\(leg.sectionTime)분)",
                        isFirst: isFirst,
                        isLast: isLast
                    )
                    
                case .bus:
                    BusTimelineRow(
                        leg: leg,
                        isFirst: isFirst,
                        isLast: isLast
                    )
                    
                case .subway:
                    SubwayTimelineRow(
                        leg: leg,
                        isFirst: isFirst,
                        isLast: isLast
                    )
                    
                case .unknown:
                    EmptyView()
                }
            }

            
            // 도착
            TimelineEndRow(
                title: route.arrivePlaceName,
                isLast: true
            )
        }
    }
}
    
extension RouteLegModel {

    static let walk1 = RouteLegModel(
        mode: .walk,
        sectionTime: 2,
        distance: 106,
        walkDescription: "도보 106m (2분)",
        startName: nil,
        endName: nil,
        routeName: nil,
        routeColor: nil,
        stations: [],
        stationCount: 0,
        options: []
    )

    static let busPreview = RouteLegModel(
        mode: .bus,
        sectionTime: 25,
        distance: 0,
        walkDescription: nil,
        startName: "중앙고등학교 정류장",
        endName: "광운대학교",
        routeName: "지선 1024",
        routeColor: "#00B493",
        stations: ["중앙고등학교", "청량리역", "회기역", "광운대역"],
        stationCount: 14,
        options: [
            TransitOptionModel(type: "지선", number: "1024", sectionTime: 4),
            TransitOptionModel(type: "간선", number: "303", sectionTime: 24)
        ]
    )

    static let subwayPreview = RouteLegModel(
        mode: .subway,
        sectionTime: 7,
        distance: 3700,
        walkDescription: nil,
        startName: "양재",
        endName: "학여울",
        routeName: "수도권 3호선",
        routeColor: "#FE5B10",
        stations: ["양재", "매봉", "도곡", "대치", "학여울"],
        stationCount: 5,
        options: []
    )

    static let walk2 = RouteLegModel(
        mode: .walk,
        sectionTime: 5,
        distance: 124,
        walkDescription: "도보 124m (5분)",
        startName: nil,
        endName: nil,
        routeName: nil,
        routeColor: nil,
        stations: [],
        stationCount: 0,
        options: []
    )
}

extension RouteResultModel {

    static let preview = RouteResultModel(
        totalDuration: 32,
        startTime: Date(),
        arriveTime: Date().addingTimeInterval(32 * 60),
        startPlaceName: "서울 성동구 하왕십리동 395-3",
        arrivePlaceName: "광운대학교 S관",
        wayPoints: [],
        legs: [
            .walk1,
            .busPreview,
            .subwayPreview,
            .walk2
        ]
    )
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
