//
//  HomeTimelineItem.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

enum HomeTimelineItem: Identifiable {
    case schedule(ScheduleSummary)
    case gap(GapTime)

    var id: String {
        switch self {
        case .schedule(let schedule): return "s-\(schedule.id)"
        case .gap(let gap): return "g-\(gap.id)"
        }
    }
}
