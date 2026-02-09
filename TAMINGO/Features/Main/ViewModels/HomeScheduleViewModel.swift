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

    var scheduleDetails: [Int: ScheduleDetail] = [:]
    
    init() {
        loadMock()
    }

    func toggleDepartureCard(for schedule: ScheduleSummary) {
        if expandedScheduleId == schedule.id {
            expandedScheduleId = nil
        } else {
            expandedScheduleId = schedule.id
            loadScheduleDetailIfNeeded(id: schedule.id)
        }
    }

    func loadScheduleDetailIfNeeded(id: Int) {
        guard scheduleDetails[id] == nil else { return }
        
        // 임시 mock
        scheduleDetails[id] = ScheduleDetail.mock(id: id)
    }


    func acceptGap(_ gap: GapTime) {
        guard let index = timelineItems.firstIndex(where: {
            if case .gap(let g) = $0 {
                return g.id == gap.id
            }
            return false
        }) else { return }

        // gap → schedule 변환
        let newSchedule = ScheduleSummary(
            id: Int.random(in: 1000...9999), // 임시 ID
            title: gap.title,
            startTime: gap.gapStartTime,
            placeName: gap.location,
            leftMinute: 0,
            duration: 0,
            isNextSchedule: false
        )

        // 같은 위치에 schedule로 교체
        timelineItems[index] = .schedule(newSchedule)
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
                    duration: 13,
                    isNextSchedule: true
                )
            ),

            .gap(
                GapTime(
                    id: 5,
                    minutes: "5–7분",
                    title: "도서 반납",
                    location: "도서관",
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
                    duration: 21,
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
                    duration: 20,
                    isNextSchedule: false
                )
            )
        ]
    }
}
