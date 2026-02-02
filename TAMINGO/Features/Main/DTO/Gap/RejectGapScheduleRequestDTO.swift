//
//  RejectGapScheduleRequestDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct RejectGapScheduleRequestDTO: Encodable {
    let date: String
    let gapStartTime: String
    let gapEndTime: String
}
