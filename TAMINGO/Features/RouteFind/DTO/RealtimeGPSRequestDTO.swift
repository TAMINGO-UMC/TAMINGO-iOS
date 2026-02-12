//
//  RealtimeGPSRequestDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/12/26.
//

import Foundation

struct RealtimeGPSRequestDTO: Encodable {
    let scheduleId: Int
    let latitude: Double
    let longitude: Double
}

struct RealtimeGPSResponseDTO: Decodable {
    let isArrived: Bool
}
