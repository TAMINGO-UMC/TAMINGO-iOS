//
//  AcceptGapScheduleRequestDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/1/26.
//

import Foundation

struct AcceptGapScheduleRequestDTO: Encodable {
    let gapStartTime: String
    let gapEndTime: String
    let title: String
    let location: LocationDTO
}
