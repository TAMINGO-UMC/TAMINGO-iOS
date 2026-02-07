//
//  ScheduleStatusDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/7/26.
//

import Foundation

struct ScheduleStatusDTO: Decodable {
    let currentStatus: CurrentStatusDTO
    let isStarted: Bool
    let leftOrDelayMinutes: Int
    let expectedDepartureTime: String
    let expectedArrivalTime: String
    let lateArrivalMinutes: Int
}

enum CurrentStatusDTO: String, Decodable {
    case ready = "READY"
    case departed = "DEPARTED"
    case departureDelayed = "DEPARTURE_DELAYED"
    case departureExtremeDelayed = "DEPARTURE_EXTREME_DELAYED"
}

extension ScheduleStatusDTO {

    func toTravelStatus() -> TravelStatus {

        let status: DepartureStatus

        switch currentStatus {

        case .ready:
            status = .preparing(
                remainingMinutes: leftOrDelayMinutes
            )

        case .departed:
            status = .now(
                remainingMinutes: leftOrDelayMinutes
            )

        case .departureDelayed:
            status = .delayed(
                remainingMinutes: leftOrDelayMinutes
            )

        case .departureExtremeDelayed:
            status = .late(
                remainingMinutes: 0,
                delayMinutes: lateArrivalMinutes
            )
        }

        return TravelStatus(
            status: status,
            expectedDepartureTime: expectedDepartureTime,
            expectedArrivalTime: expectedArrivalTime
        )
    }
}
