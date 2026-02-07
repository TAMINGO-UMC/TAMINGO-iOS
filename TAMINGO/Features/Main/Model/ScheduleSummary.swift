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
    let isNextSchedule: Bool
}

enum ScheduleCardState {
    case next
    case upcoming
    case past
}

extension ScheduleSummary {
    var startTimeText: String {
        String(startTime.prefix(5))
    }
    
    var leftMinuteText: String {
        "\(leftMinute)분 후"
    }
}
