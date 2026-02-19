//
//  DepatureStatus.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation
import SwiftUI

enum DepartureStatus {
    /// 🟢 지금 출발
    case now(remainingMinutes: Int)

    /// 🔵 출발 준비
    case preparing(remainingMinutes: Int)

    /// 🟠 출발 지연 (지각 X)
    case delayed(remainingMinutes: Int)

    /// 🔴 출발 지연 (지각 O)
    case late(remainingMinutes: Int, delayMinutes: Int)
    
    case arrivedSoon
    case arrivedDone
}


extension DepartureStatus {

    var title: String {
        switch self {
        case .now: return "지금 출발"
        case .preparing: return "출발 준비"
        case .delayed, .late: return "출발 지연"
        case .arrivedSoon: return "곧 도착"
        case .arrivedDone: return "도착 완료"
        }
    }

    var timeColor: Color {
        switch self {
        case .now: return Color("SubGreen2")
        case .preparing: return Color("SubBlue2")
        case .delayed: return Color("SubOrange2")
        case .late: return Color("SubRed2")
        default: return Color("Gray2")
        }
    }

    var backgroundColor: Color {
        switch self {
        case .now: return Color("SubGreen1")
        case .preparing: return Color("SubBlue1")
        case .delayed: return Color("SubOrange1")
        case .late: return Color("SubRed1")
        default: return Color("Gray1")
        }
    }
    
    var subTimeText: String? {
        switch self {
        case .late(_, let delay):
            return "(\(delay)분 지각)" 
        default:
            return nil
        }
    }
    
    var arrivalTimeColor: Color {
        switch self {
        case .delayed:
            return Color("SubOrange2")
        case .late:
            return Color("SubRed2")
        default:
            return Color("Black00")
        }
    }
}
