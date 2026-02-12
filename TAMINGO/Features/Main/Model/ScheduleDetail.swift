//
//  ScheduleDetail.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct ScheduleDetail: Identifiable {
    let id = UUID()
    let travel: TravelStatus
    let linkedTodos: [LinkedTodo]
    let detourRecommendations: [RouteDetour]
}

extension ScheduleDetail {
    /// ScheduleCardView에서 바로 쓰기 위한 값들
    var departureTimeText: String {
        String(travel.expectedDepartureTimeText.prefix(5))
    }
    
    var arrivalTimeText: String {
        String(travel.expectedArrivalTimeText.prefix(5))
    }
    
}

struct TravelStatus {
    let status: DepartureStatus
    let expectedDepartureTimeText: String
    let expectedArrivalTimeText: String
    let lateArrivalMinutes: Int
    let leftOrDelayMinutes: Int
    let isStarted: Bool
}

extension TravelStatus {
    var departureTimeText: String { expectedDepartureTimeText }
    var arrivalTimeText: String { expectedArrivalTimeText }
}

struct LinkedTodo: Identifiable {
    let id: Int
    let title: String
    let placeName: String
}
