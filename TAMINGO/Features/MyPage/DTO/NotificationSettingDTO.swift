//
//  NotificationSettingDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 1/25/26.
//

import Foundation
struct NotificationSettingDTO: Codable {
    let departAlertEnabled: Bool
    let departAlertMinutes: Int?
    let lateRiskAlertEnabled: Bool
    let realtimeTransitEnabled: Bool
    let todoRecommendEnabled: Bool
    let locationMoveCheckEnabled: Bool
    let routineAlertEnabled: Bool
}

enum NotificationSettingError: Error {
    case invalidDepartAlertMinutes
}

extension NotificationSettingDTO {

    func toDomain() throws -> NotificationSetting {

        let buffer: ArrivalBufferType?

        if departAlertEnabled {
            guard
                let minutes = departAlertMinutes,
                let value = ArrivalBufferType(rawValue: minutes)
            else {
                throw NotificationSettingError.invalidDepartAlertMinutes
            }
            buffer = value
        } else {
            buffer = nil
        }

        return NotificationSetting(
            departAlertEnabled: departAlertEnabled,
            departAlertMinutes: buffer,
            lateRiskAlertEnabled: lateRiskAlertEnabled,
            realtimeTransitEnabled: realtimeTransitEnabled,
            todoRecommendEnabled: todoRecommendEnabled,
            locationMoveCheckEnabled: locationMoveCheckEnabled,
            routineAlertEnabled: routineAlertEnabled
        )
    }
}
