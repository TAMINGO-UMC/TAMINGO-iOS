//
//  GapScheduleCreateResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/1/26.
//

import Foundation

struct AcceptGapScheduleResponseDTO: Decodable {
    let scheduleId: Int
    let status: GapScheduleStatusDTO
}

enum GapScheduleStatusDTO: String, Decodable {
    case scheduled = "SCHEDULED"
}

extension AcceptGapScheduleResponseDTO {
    func toModel() -> AcceptedGapSchedule {
        AcceptedGapSchedule(
            scheduleId: scheduleId,
            status: .scheduled
        )
    }
}
