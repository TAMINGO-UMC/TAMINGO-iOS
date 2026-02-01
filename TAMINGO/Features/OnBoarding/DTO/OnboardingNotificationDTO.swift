//
//  NotificationSettingDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/1/26.
//

import Foundation

// 임시 이름 - NotificationSetting으로 변경 예정
struct OnboardingNotificationDTO: Encodable {
    let departAlertEnabled: Bool
    let departAlertMinutes: String
}


extension OnboardingNotificationDTO {
    init(setting: OnboardingNotification) {
        self.departAlertEnabled = setting.isEnabled
        self.departAlertMinutes = setting.arrivalBuffer.dtoValue
    }
}
