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



enum Weekday: String, CaseIterable, Identifiable {
    case mon, tue, wed, thu, fri, sat, sun

    var id: Self { self }

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

enum WeekdayGroup: Identifiable, Equatable {
    case weekday(Weekday)
    case weekend

    var id: String {
        switch self {
        case .weekday(let day):
            return day.rawValue
        case .weekend:
            return "weekend"
        }
    }
    
    var title: String {
        switch self {
        case .weekday(let day):
            return day.displayName + "요일"
        case .weekend:
            return "주말"
        }
    }

    var subtitle: String? {
        switch self {
        case .weekend:
            return "토요일, 일요일"
        default:
            return nil
        }
    }
}

