//
//  RouteFindStartRequestDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

struct RouteFindStartRequestDTO: Encodable {
    let scheduleId: Int
    let latitude: Double
    let longitude: Double
}
