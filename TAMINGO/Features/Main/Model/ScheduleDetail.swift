//
//  ScheduleDetail.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct ScheduleDetail {
    let id: Int
    let title: String
    let startTime: String
    let duration: Int
    let location: Location
    let travel: TravelInfo
    let recommendedTodo: RouteTodo?
}

struct Location {
    let name: String
    let lat: Double
    let lng: Double
}

struct TravelInfo {
    let expectedTravelMinutes: Int
    let departureTime: String
    let arrivalTime: String
    let status: DepartureStatus
}
