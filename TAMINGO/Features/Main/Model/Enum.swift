//
//  Enum.swift
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
        case .schedule(let s): return "schedule-\(s.id)"
        case .gap(let g): return "gap-\(g.id)"
        }
    }
}
