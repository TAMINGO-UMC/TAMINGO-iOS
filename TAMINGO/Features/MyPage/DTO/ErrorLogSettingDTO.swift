//
//  ErrorLogSettingDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import Foundation

struct ErrorLogSettingDTO: Codable {
    let errorLogEnabled: Bool
}

extension ErrorLogSettingDTO {
    func toDomain() -> ErrorLogSetting {
        ErrorLogSetting(isEnabled: errorLogEnabled)
    }
}
