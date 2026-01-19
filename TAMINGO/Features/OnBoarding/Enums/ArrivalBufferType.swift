//
//  ArrivalBuffertype.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import Foundation

enum ArrivalBufferType: Int, CaseIterable, Identifiable {
    case ten = 10
    case fifteen = 15
    case thirty = 30

    var id: Int { rawValue }

    var title: String {
        "\(rawValue)분 전"
    }

    var description: String {
        "T-\(rawValue)분 기준으로 역산 알림이 전송됩니다."
    }
}
