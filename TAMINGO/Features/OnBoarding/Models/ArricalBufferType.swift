//
//  ArrivalBuffertype.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

enum ArrivalBufferType: Int, CaseIterable, Identifiable {
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

