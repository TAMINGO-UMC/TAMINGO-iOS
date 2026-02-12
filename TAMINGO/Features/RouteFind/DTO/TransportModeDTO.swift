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
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = TransportModeDTO(rawValue: rawValue) ?? .unknown
    }

    func toModel() -> TransportMode {
        switch self {
        case .walk: return .walk
        case .bus: return .bus
        case .subway: return .subway
        case .unknown: return .unknown
        }
    }
}
