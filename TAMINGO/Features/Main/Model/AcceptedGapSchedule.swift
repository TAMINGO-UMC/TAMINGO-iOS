//
//  AcceptedGapSchedule.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct AcceptedGapSchedule {
    let scheduleId: Int
    let status: GapScheduleStatus
}

enum GapScheduleStatus {
    case scheduled
}
