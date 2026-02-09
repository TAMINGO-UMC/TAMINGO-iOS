//
//  AcceptRouteTodoResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct AcceptRouteTodoResponseDTO: Decodable {
    let scheduleId: Int
    let linkedScheduleId: Int
    let status: String
}
