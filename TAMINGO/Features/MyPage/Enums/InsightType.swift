//
//  InsightType.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

enum InsightType {
    case productivity
    case arrival
    case task
    case suggestion
    case unknown
}

extension InsightType {
    init?(rawValue: String) {
        switch rawValue {
        case "PRODUCTIVITY": self = .productivity
        case "ARRIVAL": self = .arrival
        case "TASK": self = .task
        case "SUGGESTION": self = .suggestion
        default: self = .unknown
        }
    }
}
