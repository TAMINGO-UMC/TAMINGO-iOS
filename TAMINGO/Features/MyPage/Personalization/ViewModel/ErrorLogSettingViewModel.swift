//
//  ErrorLogSettingViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import Foundation

// Mock 데이터
enum ErrorLogSettingMock {
    static let enabled = ErrorLogSetting(isEnabled: true)
    static let disabled = ErrorLogSetting(isEnabled: false)
}


@Observable
final class ErrorLogSettingViewModel {

    var isEnabled: Bool

    init(setting: ErrorLogSetting = ErrorLogSettingMock.enabled) {
        self.isEnabled = setting.isEnabled
    }
}
