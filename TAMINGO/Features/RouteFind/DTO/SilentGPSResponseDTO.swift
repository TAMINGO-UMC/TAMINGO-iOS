//
//  SilentGPSResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/12/26.
//

import Foundation

struct SilentGPSResponseDTO: Decodable {
    let overridden: Bool
    let reason: String
    let snapshotMinutes: Int
    let gpsMinutes: Int
    let usedStartLat: Double
    let usedStartLng: Double
}
