//
//  Schedule.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import Foundation

struct Schedule: Identifiable {
    let id: UUID = UUID()
    let title: String
    let time: String
    let location: String
    let remainingMinutes: Int
    let isHighlighted: Bool
}

extension Schedule {
    var remainingText: String {
        if remainingMinutes < 60 {
            return "\(remainingMinutes)분 후"
        } else {
            return "\(remainingMinutes / 60)시간 후"
        }
    }
}

enum ScheduleCardState {
    case next        // 제일 첫 번째, 다음 일정
    case upcoming    // 이후 일정 (55분 후, 3시간 후)
    case past        // 이미 지난 일정 (흑백)
}
