//
//  RouteFindEndRequestDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

struct RouteFindEndRequestDTO: Encodable {
    let scheduleId: Int
    let latitude: Double
    let longitude: Double
}

struct RouteFindEndResultDTO: Decodable {
    let isArrived: Bool
}

