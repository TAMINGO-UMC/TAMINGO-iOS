//
//  TransportType.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import Foundation

enum TransportType: CaseIterable, Identifiable {
    case none
    case walk
    case subway
    case bus


    var id: Self { self }

    var title: String {
        switch self {
        case .none: return "이동 수단"
        case .walk: return "도보"
        case .subway: return "지하철"
        case .bus: return "버스"
        }
    }

}

extension TransportType {

    var dtoValue: String? {
        switch self {
        case .none: return nil
        case .walk: return "WALK"
        case .subway: return "SUBWAY"
        case .bus: return "BUS"
        }
    }

    func toDTO(rank: Int) -> TransportPreferenceDTO? {
        guard let value = dtoValue else { return nil }
        return TransportPreferenceDTO(transport: value, rank: rank)
    }
}

