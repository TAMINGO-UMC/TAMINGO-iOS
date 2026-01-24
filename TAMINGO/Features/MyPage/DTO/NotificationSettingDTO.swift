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

