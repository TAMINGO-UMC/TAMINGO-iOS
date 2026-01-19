//
//  TransportType.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import Foundation

enum TransportType: CaseIterable, Identifiable {
    case walk
    case subway
    case bus

    var id: Self { self }

    var title: String {
        switch self {
        case .walk: return "도보"
        case .subway: return "지하철"
        case .bus: return "버스"
        }
    }

}
