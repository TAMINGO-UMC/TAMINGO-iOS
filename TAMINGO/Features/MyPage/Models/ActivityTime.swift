//
//  ActivityTime.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import Foundation

struct ActivityTime {
    var startTime: Date
    var endTime: Date
    var activeDays: Set<Weekday>
}

enum Weekday: Int, CaseIterable, Hashable {
    case mon = 1
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun

    var displayName: String {
        switch self {
        case .mon: return "월"
        case .tue: return "화"
        case .wed: return "수"
        case .thu: return "목"
        case .fri: return "금"
        case .sat: return "토"
        case .sun: return "일"
        }
    }

    var isWeekend: Bool {
        self == .sat || self == .sun
    }
}
