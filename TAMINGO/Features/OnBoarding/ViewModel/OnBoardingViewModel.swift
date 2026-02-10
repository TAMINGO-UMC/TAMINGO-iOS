//
//  OnBoardingViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import Foundation

@Observable
final class OnboardingViewModel {
    
    let setupViewModel: SetupViewModel

    init(setupViewModel: SetupViewModel = SetupViewModel()) {
        self.setupViewModel = setupViewModel
    }
    
    private let onboardingService = OnboardingService()
    
    // 중복 방지
    var isSubmitting = false
    var didFinishOnboarding: Bool = false
    
    // 에러 관리
    var showErrorAlert :Bool = false
    var errorMessage: String?
    
    // intro, setup, done
    var step: OnboardingStep = .intro
    // intro 1~4
    var introPage: IntroPage = .overview

    let totalPages: Int = IntroPage.allCases.count + 1
    
    // MARK: - Intro 완료 조건들
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
            return true
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
        case .setup:
            return true
        case .done:
            return false
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

extension OnboardingViewModel {
    

    
    private func handleAPIError(_ error: APIError) {
        switch error.statusCode {
        case 409:
            didFinishOnboarding = true

        case 401:
            errorMessage = "인증이 만료되었습니다. 다시 로그인해주세요."
            showErrorAlert = true

        default:
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }


    @MainActor
    func completeOnboarding() async {
        guard !isSubmitting else { return }
            isSubmitting = true
            defer { isSubmitting = false }
        guard let request = OnboardingRequestDTO(viewModel: setupViewModel) else {
            return
        }

        do {
            _ = try await onboardingService.completeOnboarding(
                request: request
            )
            step = .done
            didFinishOnboarding = true

        } catch let error as APIError {
            handleAPIError(error)
        } catch {
            print(error)
        }
    }
}


