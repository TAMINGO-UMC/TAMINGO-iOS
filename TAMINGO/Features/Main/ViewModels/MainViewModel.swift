//
//  MainViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import Foundation
import Observation

@Observable
final class MainViewModel {

    var schedules: [Schedule] = []

    init() {
        schedules = Schedule.mockToday
    }

    var highlightedSchedule: Schedule? {
        schedules.first { $0.isHighlighted }
    }

    var normalSchedules: [Schedule] {
        schedules.filter { !$0.isHighlighted }
    }
}
