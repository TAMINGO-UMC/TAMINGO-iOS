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

        let score = productivityScore

        let grade = productivityGrade
            .flatMap { ProductivityGrade(serverValue: $0) }


        return WeeklyReportDetail(
            period: PeriodRange(start: startDate, end: endDate),

            onTimeRate: onTimeRate,
            onTimeDiff: onTimeDiff,

            taskCompletionRate: taskCompletionRate,
            taskCompletionDiff: taskCompletionDiff,
            taskDoneCount: taskDoneCount,
            taskTotalCount: taskTotalCount,

            productivityScore: score,
            grade: grade,

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
    let emoji: String
}
extension WeeklyInsightDTO {
    func toDomain() -> WeeklyInsightDomain {
        WeeklyInsightDomain(
            type: InsightType(rawValue: type) ?? .unknown,
            title: title,
            content: content,
            emoji: emoji
        )
    }
}


