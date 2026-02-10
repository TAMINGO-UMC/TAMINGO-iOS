//
//  DismissRouteTodoRequestDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct DismissRouteTodoRequestDTO: Encodable {
    let baseScheduleId: Int
    let title: String
    let location: LocationDTO
    let requiredMinutes: Int
}
