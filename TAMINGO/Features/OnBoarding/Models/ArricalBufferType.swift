//
//  ArrivalBuffertype.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

enum ArrivalBufferType: Int, CaseIterable, Identifiable, Encodable {
    case ten = 10
    case fifteen = 15
    case thirty = 30

    var id: Int { rawValue }
    
    var dtoValue: String {
        switch self {
        case .ten: return "MIN_10"
        case .fifteen: return "MIN_15"
        case .thirty: return "MIN_30"
        }
    }
}

extension ArrivalBufferType {
    init?(dtoValue: String) {
        switch dtoValue {
        case "MIN_10": self = .ten
        case "MIN_15": self = .fifteen
        case "MIN_30": self = .thirty
        default: return nil
        }
    }
}

