//
//  Enum.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/23/26.
//

import Foundation
import SwiftUI

enum DepartureStatus: Equatable {
    case preparing(remainingMinutes: Int)          // 출발 준비
    case now(remainingMinutes: Int)                // 지금 출발
    case delayed(delayMinutes: Int)                // 출발 지연
    case late(delayMinutes: Int)                   // 출발 지연 (지각)
}

extension DepartureStatus {

    var title: String {
        switch self {
        case .preparing: return "출발 준비"
        case .now: return "지금 출발"
        case .delayed: return "출발 지연"
        case .late: return "출발 지연"
        }
    }

    var timeText: String {
        switch self {
        case .preparing(let min):
            return "1시간 \(min)분"

        case .now(let min):
            return "0시간 \(min)분"

        case .delayed(let min):
            return "-0시간 \(min)분"

        case .late(let min):
            return "-0시간 \(min)분"
        }
    }

    var subTimeText: String? {
        switch self {
        case .late(let min):
            return "(\(min)분 지각)"
        default:
            return nil
        }
    }

    var timeColor: Color {
        switch self {
        case .preparing: return Color("SubBlue2")
        case .now: return Color("SubGreen2")
        case .delayed: return Color("SubOrange2")
        case .late: return Color("SubRed2")
        }
    }

    var backgroundColor: Color {
        switch self {
        case .preparing:
            return Color("SubBlue1")
        case .now:
            return Color("SubGreen1")
        case .delayed:
            return Color("SubOrange1")
        case .late:
            return Color("SubRed1")
        }
    }

    var arrivalTimeColor: Color {
        switch self {
        case .delayed:
            return Color("SubOrange2")
        case .late:
            return Color("SubRed2")
        default:
            return .black
        }
    }
}

