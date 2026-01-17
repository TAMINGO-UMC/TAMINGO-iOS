//
//  OnboardingSteps.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import Foundation

enum OnboardingStep: Int {
    case intro // 1~4
    case setup // 5
    case done
}

enum OnboardingSubtitle {
    case none
    case text(String)
    case image(String) // 이미지 이름만
}
