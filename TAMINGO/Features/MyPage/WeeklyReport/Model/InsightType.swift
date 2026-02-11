//
//  InsightType.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import SwiftUI

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

extension InsightType {

    var borderColor: Color {
        switch self {
        case .productivity:
            return .subGreen2
        case .arrival:
            return .subYellow2
        case .task:
            return .subBlue3
        case .suggestion:
            return .subPink1
        case .unknown:
            return .gray1
        }
    }

    var backgroundColor: Color {
        switch self {
        case .productivity:
            return .subGreen1
        case .arrival:
            return .subYellow
        case .task:
            return .subBlue1
        case .suggestion:
            return .subPink
        case .unknown:
            return .gray0
        }
    }

    var titleColor: Color {
        switch self {
        case .productivity:
            return .subGreen3
        case .arrival:
            return .subYellow3
        case .task:
            return .subBlue2
        case .suggestion:
            return .subPink2
        case .unknown:
            return .gray2
        }
    }
}
