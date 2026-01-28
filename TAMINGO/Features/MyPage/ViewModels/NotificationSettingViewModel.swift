//
//  NotificationSettingViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/25/26.
//

import Foundation

// Mock 데이터
enum NotificationSettingMock {

    static let `default` = NotificationSetting(
        departAlertEnabled: true,
        departAlertMinutes: .ten,
        lateRiskAlertEnabled: true,
        realtimeTransitEnabled: true,
        todoRecommendEnabled: true,
        locationMoveCheckEnabled: false,
        routineAlertEnabled: true
    )

    static let allDisabled = NotificationSetting(
        departAlertEnabled: false,
        departAlertMinutes: nil,
        lateRiskAlertEnabled: false,
        realtimeTransitEnabled: false,
        todoRecommendEnabled: false,
        locationMoveCheckEnabled: false,
        routineAlertEnabled: false
    )
}

@Observable
final class NotificationSettingViewModel {

    var departAlertEnabled: Bool
    var departAlertMinutes: ArrivalBufferType?
    var lateRiskAlertEnabled: Bool
    var realtimeTransitEnabled: Bool
    var todoRecommendEnabled: Bool
    var locationMoveCheckEnabled: Bool
    var routineAlertEnabled: Bool

    init(setting: NotificationSetting = NotificationSettingMock.`default`) {
        self.departAlertEnabled = setting.departAlertEnabled
        self.departAlertMinutes = setting.departAlertMinutes
        self.lateRiskAlertEnabled = setting.lateRiskAlertEnabled
        self.realtimeTransitEnabled = setting.realtimeTransitEnabled
        self.todoRecommendEnabled = setting.todoRecommendEnabled
        self.locationMoveCheckEnabled = setting.locationMoveCheckEnabled
        self.routineAlertEnabled = setting.routineAlertEnabled
    }
}


