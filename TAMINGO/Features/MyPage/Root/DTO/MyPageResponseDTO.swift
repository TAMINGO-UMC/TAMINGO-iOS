//
//  MyPageResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/9/26.
//

import Foundation

struct MyPageResponseDTO: Decodable {
    let profile: UserProfileDTO
    let weeklyReport: WeeklyReportDTO?
    let counts: MyPageCountsDTO
    let integration: IntegrationDTO
    let settings: SettingsDTO
}

struct WeeklyReportDTO: Decodable {
    let weekStartDate: String?
    let weekEndDate: String?
    let onTimeRate: Double?
    let onTimeDiff: Double?
    let taskCompletionRate: Double?
    let taskDoneCount: Int?
    let taskTotalCount: Int?
    let productivityScore: Int?
    let productivityGrade: String?
}

struct UserProfileDTO: Decodable {
    let nickname: String
    let email: String
}

struct MyPageCountsDTO: Decodable {
    let scheduleCategoryCount: Int
    let todoCategoryCount: Int
    let favoritePlaceCount: Int
}

struct IntegrationDTO: Decodable {
    let linked: Bool
    let syncFromApple: Bool
    let status: String?
}

struct SettingsDTO: Decodable {
    let activeStartTime: String
    let activeEndTime: String
    let transportPriority: [String]
    let importantAlarmEnabled: Bool
    let learningDataEnabled: Bool
}

extension MyPageResponseDTO {
    func toDomain() -> MyPage {
        MyPage(
            profile: profile.toDomain(),
            weeklyReport: weeklyReport?.toDomain(),
            counts: counts.toDomain(),
            integration: integration.toDomain(),
            settings: settings.toDomain()
        )
    }
}

extension UserProfileDTO {
    func toDomain() -> UserProfile {
        UserProfile(
            name: nickname,
            email: email
        )
    }
}

extension WeeklyReportDTO {

    func toDomain() -> WeeklyReportSummary {

        let startDate = weekStartDate?.toDateOnly()
            ?? PeriodRange.default.start

        let endDate = weekEndDate?.toDateOnly()
            ?? PeriodRange.default.end

        return WeeklyReportSummary(
            period: PeriodRange(
                start: startDate,
                end: endDate
            ),
            onTimeRate: onTimeRate.map { Int($0) },
            onTimeDiff: onTimeDiff.map { Int($0) },
            taskDoneCount: taskDoneCount,
            taskTotalCount: taskTotalCount,
            productivityScore: productivityScore,
            grade: productivityGrade.flatMap { ProductivityGrade(serverValue: $0) }
            )
    }
}


extension MyPageCountsDTO {
    func toDomain() -> MyPageCounts {
        MyPageCounts(
            scheduleCategoryCount: scheduleCategoryCount,
            todoCategoryCount: todoCategoryCount,
            favoritePlaceCount: favoritePlaceCount
        )
    }
}

extension IntegrationDTO {
    func toDomain() -> Integration {
        Integration(
            linked: linked,
            syncFromApple: syncFromApple,
            status: status.flatMap { IntegrationStatus(rawValue: $0) }
        )
    }
}

extension SettingsDTO {
    func toDomain() -> MyPageSettings {

        let start = activeStartTime.toTimeOnlyDate()
        let end = activeEndTime.toTimeOnlyDate()

        return MyPageSettings(
            activityTime: ActivityTime(
                startTime: start ?? ActivityTime.default.startTime,
                endTime: end ?? ActivityTime.default.endTime,
                activeDays: []
            ),
            notification: NotificationSetting(
                departAlertEnabled: importantAlarmEnabled,
                departAlertMinutes: nil,
                lateRiskAlertEnabled: false,
                realtimeTransitEnabled: false,
                todoRecommendEnabled: false,
                locationMoveCheckEnabled: false,
                routineAlertEnabled: false
            ),
            transportPriority: transportPriority.compactMap {
                TransportType(serverValue: $0)
            },
            learningDataEnabled: ErrorLogSetting(
                isEnabled: learningDataEnabled
            )
        )
    }
}
