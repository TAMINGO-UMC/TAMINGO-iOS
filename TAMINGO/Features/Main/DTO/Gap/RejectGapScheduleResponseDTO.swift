//
//  RejectGapScheduleResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct RejectGapScheduleResponseDTO: Decodable {
    let status: GapScheduleDismissStatusDTO
}

enum GapScheduleDismissStatusDTO: String, Decodable {
    case dismissed = "DISMISSED"
}

extension RejectGapScheduleResponseDTO {
    func toModel() -> RejectedGapSchedule {
        RejectedGapSchedule(status: .dismissed)
    }
}
