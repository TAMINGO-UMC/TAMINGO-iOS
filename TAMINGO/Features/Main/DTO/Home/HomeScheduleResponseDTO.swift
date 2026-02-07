//
//  ScheduleResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/1/26.
//

import Foundation

// MARK: - Root Response
struct HomeScheduleResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: HomeScheduleResultDTO
}

// MARK: - Result
struct HomeScheduleResultDTO: Decodable {
    let date: String
    let items: [HomeScheduleItemDTO]
}

struct HomeScheduleItemDTO: Decodable {
    // SCHEDULE
    let scheduleId: Int?
    let title: String?
    let startTime: String?
    let placeName: String?
    let leftMinute: Int?
    let duration: Int?
    let nextSchedule: Bool?

    // GAP_RECOMMEND
    let suggestionId: Int?
    let location: String?
    let requiredMinutes: Int?
    let time: String?
    let message: String?
    
    let type: ScheduleItemType
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
                let duration,
                let nextSchedule
            else { return nil }
            
            return .schedule(
                ScheduleSummary(
                    id: scheduleId,
                    title: title,
                    startTime: startTime,
                    placeName: placeName,
                    leftMinute: leftMinute,
                    duration: duration,
                    isNextSchedule: nextSchedule
                )
            )
            
        case .gapRecommend:
            guard
                let suggestionId,
                let title,
                let location,
                let time,
                let requiredMinutes,
                let message
            else { return nil }
            
            return .gap(
                GapTime(
                    id: suggestionId,
                    minutes: "약 \(requiredMinutes)분",
                    title: title,
                    location: location,
                    availableText: message,
                    gapStartTime: time,
                    gapEndTime: time
                )
            )
        }
    }
}
