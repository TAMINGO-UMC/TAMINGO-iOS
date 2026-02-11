//
//  WeeklyReportResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
struct WeeklyReportDetailResponseDTO: Decodable {
    let weekStartDate: String
    let weekEndDate: String

    let onTimeRate: Int
    let onTimeDiff: Int

    let taskCompletionRate: Int
    let taskCompletionDiff: Int
    let taskTotalCount: Int
    let taskDoneCount: Int

    let productivityScore: Int
    let productivityGrade: String

    let dailyActivities: [DailyActivityDTO]
    let insights: [WeeklyInsightDTO]
}


struct DailyActivityDTO: Decodable {
    let dayOfWeek: String   // "MONDAY"
    let scheduleCount: Int
    let taskCount: Int
    let activityRate: Int
}

struct WeeklyInsightDTO: Decodable {
    let type: String
    let title: String
    let content: String
    let modelVersion: String
}
extension WeeklyInsightDTO {
    func toDomain() -> WeeklyInsightDomain {
        WeeklyInsightDomain(
            type: InsightType(rawValue: type) ?? .unknown,
            title: title,
            content: content
        )
    }
}


