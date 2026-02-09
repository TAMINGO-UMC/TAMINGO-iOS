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


extension ScheduleDetail {

    static func mock(id: Int) -> ScheduleDetail {
        ScheduleDetail(
            id: id,
            title: "팀플 미팅",
            startTime: "09:40",
            duration: 60,
            location: Location(
                name: "명동역 약국",
                lat: 37.56,
                lng: 127.02
            ),
            travel: TravelInfo(
                expectedTravelMinutes: 30,
                departureTime: "오전 08:40",
                arrivalTime: "오전 09:10",
                status: .preparing(remainingMinutes: 5)
            ),
            recommendedTodo: RouteTodo(
                location: Location(
                    name: "명동역 약국",
                    lat: 37.56,
                    lng: 127.02
                ),
                detourMinutes: 5
            )
        )
    }
}
