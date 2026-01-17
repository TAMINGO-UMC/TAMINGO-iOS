//
//  OnBoardingViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import Foundation

@Observable
final class OnboardingViewModel {

    // MARK: - State
    var step: OnboardingStep = .intro
    var introPage: IntroPage = .overview

    // MARK: - Constants
    let totalPages: Int = IntroPage.allCases.count + 1 // intro 4 + setup 1

    // MARK: - Computed

    /// 전체 기준 페이지 인덱스 (PageIndicator용)
    var currentGlobalIndex: Int {
        switch step {
        case .intro:
            return introPage.rawValue
        case .setup:
            return IntroPage.allCases.count
        case .done:
            return totalPages - 1
        }
    }

    /// 현재 헤더 정보
    var header: (title: String, subtitle: OnboardingSubtitle) {
        switch step {
        case .intro:
            return (introPage.title, introPage.subtitle)
        case .setup:
            return (
                "당신에게 딱 맞는\n하루를 설계 중입니다",
                .none
            )
        case .done:
            return ("", .none)
        }
    }

    /// StepIndicator에 보여줄 스텝 번호
    var stepIndex: Int {
        currentGlobalIndex + 1
    }

    // MARK: - Actions

    func goNext() {
        switch step {
        case .intro:
            if let next = IntroPage(rawValue: introPage.rawValue + 1) {
                introPage = next
            } else {
                step = .setup
            }

        case .setup:
            step = .done

        case .done:
            break
        }
    }
}

