//
//  TravelInfoDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct TravelInfoDTO: Decodable {
    let expectedTravelMinutes: Int
    let recommendedDepartureTime: String
    let recommendedArrivalTime: String
    let departureStatus: DepartureStatusDTO
    let scheduleStatus: ScheduleStatusDTO
    let delayMinutes: Int?
}

enum DepartureStatusDTO: String, Decodable {
    case now = "NOW"
    case ready = "READY"
    case waiting = "WAITING"
    case late = "LATE"
}

enum ScheduleStatusDTO: String, Decodable {
    case before = "BEFORE"
    case after = "AFTER"
}

extension DepartureStatusDTO {
    
    func toDomain(
        remainingMinutes: Int,
        delayMinutes: Int?
    ) -> DepartureStatus {
        
        switch self {
            
        case .now:
            return .now(remainingMinutes: remainingMinutes)
            
        case .ready, .waiting:
            return .preparing(remainingMinutes: remainingMinutes)
            
        case .late:
            let delay = max(0, delayMinutes ?? 0)
            return .late(
                remainingMinutes: remainingMinutes,
                delayMinutes: delay
            )
        }
    }
}
