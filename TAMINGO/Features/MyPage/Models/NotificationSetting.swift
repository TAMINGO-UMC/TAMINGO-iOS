//
//  NotificationSetting.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

// 온보딩에서도 사용
struct NotificationSetting {
    let departAlertEnabled: Bool
    let departAlertMinutes: ArrivalBufferType?
    let lateRiskAlertEnabled: Bool
    let realtimeTransitEnabled: Bool
    let todoRecommendEnabled: Bool
    let locationMoveCheckEnabled: Bool
    let routineAlertEnabled: Bool
}
