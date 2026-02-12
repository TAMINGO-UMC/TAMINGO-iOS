//
//  ScheduleSummary.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/1/26.
//

import Foundation

struct ScheduleSummary: Identifiable, Hashable {
    let id: Int
    let title: String
    let startTime: String
    let placeName: String
    let leftMinute: Int
    let duration: Int
    let isNowSchedule: Bool
}

enum ScheduleCardState {
    case now
    case upcoming
    case past
}

extension ScheduleSummary {
    var startTimeText: String {
        String(startTime.prefix(5))
    }
    
    var leftMinuteText: String {
        if leftMinute <= 0 {
            return "지금"
        }

        if leftMinute < 60 {
            return "\(leftMinute)분 후"
        }

        let hours = leftMinute / 60
        return "\(hours)시간 후"
    }
}
