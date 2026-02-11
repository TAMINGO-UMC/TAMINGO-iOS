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

    let onTimeRate: Int?
    let onTimeDiff: Int?

    let taskCompletionRate: Int?
    let taskCompletionDiff: Int?
    let taskTotalCount: Int?
    let taskDoneCount: Int?

    let productivityScore: Int?
    let productivityGrade: String?

    let dailyActivities: [DailyActivityDTO]?
    let insights: [WeeklyInsightDTO]?
}
extension WeeklyReportDetailResponseDTO {

    func toDomain() -> WeeklyReportDetail {

        let startDate = weekStartDate.toDateOnly()
            ?? PeriodRange.default.start

        let endDate = weekEndDate.toDateOnly()
            ?? PeriodRange.default.end

        let score = productivityScore ?? 0

        return WeeklyReportDetail(
            period: PeriodRange(start: startDate, end: endDate),

            onTimeRate: onTimeRate ?? 0,
            onTimeDiff: onTimeDiff ?? 0,

            taskCompletionRate: taskCompletionRate ?? 0,
            taskCompletionDiff: taskCompletionDiff ?? 0,
            taskDoneCount: taskDoneCount ?? 0,
            taskTotalCount: taskTotalCount ?? 0,

            productivityScore: score,
            grade: ProductivityGrade.from(score: score),

            dailyActivities: (dailyActivities ?? []).map { $0.toDomain() },
            insights: (insights ?? []).map { $0.toDomain() }
        )
    }
}


struct DailyActivityDTO: Decodable {
    let dayOfWeek: String   // "MONDAY"
    let scheduleCount: Int
    let taskCount: Int
    let activityRate: Int
}
extension DailyActivityDTO {

    func toDomain() -> DailyActivity {
        DailyActivity(
            day: Weekday(rawValue: dayOfWeek) ?? .mon,
            scheduleCount: scheduleCount,
            taskCount: taskCount,
            activityRate: activityRate
        )
    }
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


