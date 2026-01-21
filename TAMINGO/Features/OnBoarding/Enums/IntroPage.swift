//
//  IntroPage.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import Foundation

enum IntroPage : Int, CaseIterable {
    case overview = 0
    case flow = 1
    case calendar = 2
    case permission = 3
    
    var title: String {
        switch self {
        case .overview:
            return "당신의 일정을 관리할 똑똑한 비서"
        case .calendar:
            return "당신의 일정이 필요해요"
        case .flow:
            return "놓치지 말아야 할\n모든 일의 동선을 짜드려요"
        case .permission:
            return "자, 이제 제가\n일할 준비를 할게요!"
        }
    }

    var subtitle: OnboardingSubtitle {
        switch self {
        case .overview:
            return .image("Tamingo_logo_text")
        case .calendar:
            return .text("캘린더를 연동하면 타밍고가 모든 일정을 자동으로 불러와\n실시간 교통 정보를 반영해 지각 없는 최적의 출발 시각을 계산합니다.")
        case .flow, .permission:
            return .none
        }
    }
}
