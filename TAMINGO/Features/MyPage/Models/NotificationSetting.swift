//
//  NotificationSetting.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//


struct NotificationSetting {
    let departAlertEnabled: Bool
    let departAlertMinutes: ArrivalBufferType?
    let lateRiskAlertEnabled: Bool
    let realtimeTransitEnabled: Bool
    let todoRecommendEnabled: Bool
    let locationMoveCheckEnabled: Bool
    let routineAlertEnabled: Bool
}


extension NotificationSetting {
    func toDTO() -> NotificationSettingDTO {
        NotificationSettingDTO(
            departAlertEnabled: departAlertEnabled,
            departAlertMinutes: departAlertMinutes?.dtoValue,
            lateRiskAlertEnabled: lateRiskAlertEnabled,
            realtimeTransitEnabled: realtimeTransitEnabled,
            todoRecommendEnabled: todoRecommendEnabled,
            locationMoveCheckEnabled: locationMoveCheckEnabled,
            routineAlertEnabled: routineAlertEnabled
        )
    }
}

