//
//  PeriodOption.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//
import Foundation

enum PeriodOption: Identifiable, CaseIterable {
    case thisWeek
    case lastWeek
    case thisMonth

    var id: Self { self }
    
    var displayTitle: String {
        switch self {
        case .thisWeek: return "이번 주"
        case .lastWeek: return "지난 주"
        case .thisMonth: return "이번 달"
        }
    }
}

struct PeriodRange {
    let start: Date
    let end: Date
    
    var formatted: String {
        "\(start.toString(format: "M/d")) - \(end.toString(format: "M/d"))"
    }
}

