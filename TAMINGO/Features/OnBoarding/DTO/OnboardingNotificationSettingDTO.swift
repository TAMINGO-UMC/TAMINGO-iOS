//
//  OnboardingNotificationSettingDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/8/26.
//

import Foundation

struct OnboardingNotificationSettingDTO: Encodable {
    let departAlertEnabled: Bool
    let departAlertMinutes: String
}

extension OnboardingNotificationSetting {
    func toDTO() -> OnboardingNotificationSettingDTO {
        OnboardingNotificationSettingDTO(
            departAlertEnabled: departAlertEnabled,
            departAlertMinutes: departAlertMinutes.dtoValue
        )
    }
}
