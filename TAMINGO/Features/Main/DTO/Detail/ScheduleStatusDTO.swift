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
            status = .preparing(remainingMinutes: leftOrDelayMinutes)

        case .departed:
            status = .now(remainingMinutes: leftOrDelayMinutes)

        case .departureDelayed:
            status = .delayed(remainingMinutes: leftOrDelayMinutes)

        case .departureExtremeDelayed:
            status = .late(
                remainingMinutes: leftOrDelayMinutes,
                delayMinutes: lateArrivalMinutes
            )
        }
        
        return TravelStatus(
            status: status,
            expectedDepartureTimeText: expectedDepartureTime.hhmm,
            expectedArrivalTimeText: expectedArrivalTime.hhmm,
            lateArrivalMinutes: lateArrivalMinutes,
            leftOrDelayMinutes: leftOrDelayMinutes,
            isStarted: isStarted
        )
    }
}


extension String {
    var hhmm: String {
        // 1) ISO면 T 뒤만
        let tSplit = self.split(separator: "T", maxSplits: 1, omittingEmptySubsequences: true)
        let timePart = (tSplit.count == 2) ? String(tSplit[1]) : self

        // 2) "03:30:00" → "03:30"
        let comps = timePart.split(separator: ":")
        guard comps.count >= 2 else { return self }
        let h = comps[0]
        let m = comps[1]
        return "\(h):\(m)"
    }
}
