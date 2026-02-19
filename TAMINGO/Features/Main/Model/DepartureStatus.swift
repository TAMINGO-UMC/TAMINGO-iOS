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

    /// 🟠 출발 지연 (지각 X) : 출발 예상 시간이 늦어짐
    case delayed(delayMinutes: Int)

    /// 🔴 출발 지연 (지각 O) : 도착 예상 시간이 일정(약속)보다 늦음
    case late(delayMinutes: Int)

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

    /// 빨강일 때만 “(n분 지각)” 표시 (※ n은 "도착 지각분"이어야 함)
    func subTimeText(lateArrivalMinutes: Int) -> String? {
        switch self {
        case .late:
            return "(\(max(0, lateArrivalMinutes))분 지각)"
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

    var isDelayStyle: Bool {
        switch self {
        case .delayed, .late: return true
        default: return false
        }
    }
}
