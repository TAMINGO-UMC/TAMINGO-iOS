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

struct TravelStatus {
    let status: DepartureStatus
    let expectedDepartureTime: String
    let expectedArrivalTime: String
}

extension TravelStatus {

    var departureTimeText: String {
        String(expectedDepartureTime.prefix(5))
    }

    var arrivalTimeText: String {
        String(expectedArrivalTime.prefix(5))
    }
}

struct LinkedTodo: Identifiable {
    let id: Int
    let title: String
    let placeName: String
}
