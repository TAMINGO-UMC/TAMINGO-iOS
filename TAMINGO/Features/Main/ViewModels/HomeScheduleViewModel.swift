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

    var timelineItems: [HomeTimelineItem] = []
    var expandedScheduleId: Int?

    init() {
        loadMock()
    }

    func toggleDepartureCard(for schedule: ScheduleSummary) {
        expandedScheduleId =
        expandedScheduleId == schedule.id ? nil : schedule.id
    }

    func acceptGap(_ gap: GapTime) {
        timelineItems.removeAll {
            if case .gap(let g) = $0 { return g.id == gap.id }
            return false
        }
    }

    func rejectGap(_ gap: GapTime) {
        timelineItems.removeAll {
            if case .gap(let g) = $0 { return g.id == gap.id }
            return false
        }
    }

    private func loadMock() {
        timelineItems = [
            .schedule(
                ScheduleSummary(
                    id: 1,
                    title: "팀플 미팅",
                    startTime: "09:40",
                    placeName: "S관 301",
                    leftMinute: 23,
                    isNextSchedule: true
                )
            ),

            .gap(
                GapTime(
                    id: 5,
                    minutes: "5–7분",
                    title: "도서 반납",
                    location: "도서관 · 도보 5분",
                    availableText: "12:10–12:30 공강에 처리 가능",
                    gapStartTime: "12:10",
                    gapEndTime: "12:30"
                )
            ),

            .schedule(
                ScheduleSummary(
                    id: 2,
                    title: "강의",
                    startTime: "14:00",
                    placeName: "공학관",
                    leftMinute: 55,
                    isNextSchedule: false
                )
            ),

            .schedule(
                ScheduleSummary(
                    id: 3,
                    title: "스터디",
                    startTime: "18:30",
                    placeName: "중앙도서관",
                    leftMinute: 180,
                    isNextSchedule: false
                )
            )
        ]
    }
}


//@Observable
//final class HomeScheduleViewModel {
//
//    // MARK: - Data
//    let schedules: [Schedule]
//    let nextScheduleId: UUID?
//
//    // MARK: - UI State
//    var showDepartureCard: Bool = false
//    var expandedScheduleId: UUID? = nil
//    var departureStatus: DepartureStatus = .preparing(remainingMinutes: 5)
//
//    // MARK: - Init
//    init(schedules: [Schedule]) {
//        self.schedules = schedules
//
//        // 다음 일정 = 아직 지나지 않은 일정 중 가장 빠른 것
//        self.nextScheduleId = schedules
//            .filter { $0.remainingMinutes >= 0 }
//            .min(by: { $0.remainingMinutes < $1.remainingMinutes })?
//            .id
//    }
//
//    // MARK: - Schedule Card State
//    func state(for schedule: Schedule) -> ScheduleCardState {
//        if schedule.remainingMinutes < 0 {
//            return .past
//        }
//        if schedule.id == nextScheduleId {
//            return .next
//        }
//        return .upcoming
//    }
//
//    // MARK: - Departure Card Control
//    func toggleDepartureCard(for schedule: Schedule) {
//        if expandedScheduleId == schedule.id {
//            expandedScheduleId = nil
//        } else {
//            expandedScheduleId = schedule.id
//        }
//    }
//}
