//
//  TransportModeDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

enum TransportModeDTO: String, Decodable {
    case walk = "WALK"
    case bus = "BUS"
    case subway = "SUBWAY"
}

extension TransportModeDTO {
    func toModel() -> TransportMode {
        switch self {
        case .walk: return .walk
        case .bus: return .bus
        case .subway: return .subway
        }
    }
}
