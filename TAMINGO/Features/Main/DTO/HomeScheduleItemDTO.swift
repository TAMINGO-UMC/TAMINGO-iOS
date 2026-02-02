//
//  ScheduleItemDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/1/26.
//

import Foundation

struct HomeScheduleItemDTO: Decodable {
    let type: ScheduleItemType

    // SCHEDULE
    let scheduleId: Int?
    let title: String?
    let startTime: String?
    let placeName: String?
    let leftMinute: Int?
    let nextSchedule: Bool?

    // GAP_RECOMMEND
    let suggestionId: Int?
    let location: String?
    let time: String?
    let requiredMinutes: Int?
    let message: String?
}

enum ScheduleItemType: String, Decodable {
    case schedule = "SCHEDULE"
    case gapRecommend = "GAP_RECOMMEND"
}

extension HomeScheduleItemDTO {

    func toModel() -> HomeTimelineItem? {
        switch type {

        case .schedule:
            guard
                let scheduleId,
                let title,
                let startTime,
                let placeName,
                let leftMinute,
                let nextSchedule
            else { return nil }

            return .schedule(
                ScheduleSummary(
                    id: scheduleId,
                    title: title,
                    startTime: startTime,
                    placeName: placeName,
                    leftMinute: leftMinute,
                    isNextSchedule: nextSchedule
                )
            )

        case .gapRecommend:
            guard
                let suggestionId,
                let message,
                let time
            else { return nil }

            return .gap(
                GapTime(
                    id: suggestionId,
                    minutes: "약 5–7분",
                    title: "추천 일정",
                    location: "근처 장소",
                    availableText: message,
                    gapStartTime: time,
                    gapEndTime: time
                )
            )
        }
    }
}
