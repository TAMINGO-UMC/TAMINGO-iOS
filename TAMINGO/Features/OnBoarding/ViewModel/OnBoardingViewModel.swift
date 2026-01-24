//
//  OnBoardingViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import Foundation

@Observable
final class OnboardingViewModel {
    
    // intro, setup, done
    var step: OnboardingStep = .intro
    // intro 1~4
    var introPage: IntroPage = .overview

    let totalPages: Int = IntroPage.allCases.count + 1
    
    // MARK: - Intro 완료 조건들
    var didConnectCalendar: Bool = false
    var didGrantPermission: Bool = false

    // MARK: - Setup 완료 여부
    var isSetupCompleted: Bool = false

    // MARK: - Next 가능 여부
    var canGoNext: Bool {
        switch step {
        case .intro:
            return canGoNextIntro
        case .setup:
            return isSetupCompleted
        case .done:
            return false
        }
    }

    private var canGoNextIntro: Bool {
        switch introPage {
        case .overview:
            return true
        case .calendar:
            return didConnectCalendar
        case .flow:
            return true
        case .permission:
            return didGrantPermission
        }
    }
    
    // MARK: - Prev 가능 여부
    var canGoPrevious: Bool {
        switch step {
        case .intro:
            return introPage != .overview
        case .setup, .done:
            return true
        }
    }


    // MARK: - 전체 기준 페이지 인덱스(PageIndicator용)
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

    // 현재 헤더 정보
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

    // MARK: - 스텝 번호(StepIndicator용)
    var stepIndex: Int {
        currentGlobalIndex + 1
    }

    // 다음 버튼 동작
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
    
    func goPrevious() {
        switch step {
        case .intro:
            guard let prev = IntroPage(rawValue: introPage.rawValue - 1) else {
                return
            }
            introPage = prev
            
        case .setup:
            step = .intro
            introPage = IntroPage.allCases.last ?? .overview
        case .done:
            break
        }
    }
    
}

