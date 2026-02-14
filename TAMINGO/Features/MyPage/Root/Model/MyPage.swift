//
//  MyPage.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation

struct MyPage {
    let profile: UserProfile
    let weeklyReport: WeeklyReportSummary?
    let counts: MyPageCounts
    let integration: Integration
    let settings: MyPageSettings
}

struct MyPageSettings {
    let activityTime: ActivityTime
    let notification: NotificationSetting
    let transportPriority: [TransportType]
    let learningDataEnabled: ErrorLogSetting
}

struct MyPageCounts {
    let scheduleCategoryCount: Int
    let todoCategoryCount: Int
    let favoritePlaceCount: Int
}

struct Integration {
    let linked: Bool
    let syncFromApple: Bool
    let status: IntegrationStatus?
}

enum IntegrationStatus: String {
    case active = "ACTIVE"
    case inactive = "INACTIVE"
}

struct NotificationSetting {
    let departAlertEnabled: Bool
    let departAlertMinutes: ArrivalBufferType?
    let lateRiskAlertEnabled: Bool
    let realtimeTransitEnabled: Bool
    let todoRecommendEnabled: Bool
    let locationMoveCheckEnabled: Bool
    let routineAlertEnabled: Bool
}

struct ErrorLogSetting {
    let isEnabled: Bool
}
