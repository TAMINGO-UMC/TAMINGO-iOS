//
//  OnBoardingContainerView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI

struct OnBoardingContainerView: View {

    @State private var vm = OnboardingViewModel()

    var body: some View {
        VStack(spacing: 0) {

            VStack(spacing: 0) {
                StepIndicatorView(
                    currentStep: vm.stepIndex,
                    totalSteps: vm.totalPages
                )
                .padding(.top, 28)

                OnboardingHeaderView(
                    title: vm.header.title,
                    subtitle: vm.header.subtitle
                )
                .padding(.top, 5)
            }
            .frame(height: 140)
            

            VStack(spacing: 0) {

                contentView
                    .padding(.top, 31)
                    .padding(.bottom, 22)

                PageIndicatorView(
                    currentPage: vm.currentGlobalIndex,
                    totalPages: vm.totalPages
                )
                .padding(.bottom, 47)

                Button("다음") {
                    vm.goNext()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(.mainMint)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding(.horizontal, 24)
                .padding(.bottom, 26)
            }
        }
    }


    @ViewBuilder
    private var contentView: some View {
        switch vm.step {
        case .intro:
            IntroContainerView(page: vm.introPage)
        case .setup:
            SetupView()
        case .done:
            Text("온보딩 완료")
        }
    }
}



#Preview {
    OnBoardingContainerView()
}
