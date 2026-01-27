//
//  HomeScheduleViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/23/26.
//

import SwiftUI
import Observation

@Observable
final class HomeScheduleViewModel {

    // MARK: - Data
    let schedules: [Schedule]
    let nextScheduleId: UUID?

    // MARK: - UI State
    var showDepartureCard: Bool = false
    var expandedScheduleId: UUID? = nil
    var departureStatus: DepartureStatus = .preparing(remainingMinutes: 5)
    
    // MARK: - Init
    init(schedules: [Schedule]) {
        self.schedules = schedules

        // 다음 일정 = 아직 지나지 않은 일정 중 가장 빠른 것
        self.nextScheduleId = schedules
            .filter { $0.remainingMinutes >= 0 }
            .min(by: { $0.remainingMinutes < $1.remainingMinutes })?
            .id
    }

    // MARK: - Schedule Card State
    func state(for schedule: Schedule) -> ScheduleCardState {
        if schedule.remainingMinutes < 0 {
            return .past
        }
        if schedule.id == nextScheduleId {
            return .next
        }
        return .upcoming
    }

    // MARK: - Departure Card Control
    func toggleDepartureCard(for schedule: Schedule) {
        if expandedScheduleId == schedule.id {
            expandedScheduleId = nil
        } else {
            expandedScheduleId = schedule.id
        }
    }
}

