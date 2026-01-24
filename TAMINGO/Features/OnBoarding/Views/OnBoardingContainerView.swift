//
//  OnBoardingContainerView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI

struct OnBoardingContainerView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var vm = OnboardingViewModel()

    var body: some View {
        VStack(spacing: 0) {

            VStack(spacing: 0) {
                StepIndicatorView(
                    currentStep: vm.stepIndex,
                )
                .padding(.top, 28)

                OnboardingHeaderView(
                    title: vm.header.title,
                    subtitle: vm.header.subtitle
                )
                .padding(.top, 5)
            }
            .frame(height: 140, alignment: .top)

            contentView
                .padding(.top, 31)
                .padding(.bottom, 22)
            PageIndicatorView(
                currentPage: vm.currentGlobalIndex,
                totalPages: vm.totalPages
            )
            .padding(.bottom, 47)

            buttons
        }
        .onChange(of: vm.step) { oldValue, newValue in
            if newValue == .done {
                dismiss()
            }
        }
    }


    @ViewBuilder
    private var contentView: some View {
        switch vm.step {
        case .intro:
            IntroContainerView(
                vm: $vm,
                page: vm.introPage
            )
            .shadow(
                color: .black.opacity(0.05),
                radius: 4,
                x: 0,
                y: 2.069
            )
        case .setup:
            SetupView(isCompleted: $vm.isSetupCompleted)
        case .done:
            EmptyView()
        }
        
    }
    
    var buttons: some View {
        HStack{
            if vm.canGoPrevious {
                Button {
                    vm.goPrevious()
                } label: {
                    Text("이전")
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .font(.semiBold14)
                        .foregroundColor(.mainMint)
                        .background(.subMint)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.mainMint, lineWidth: 1)
                        )
                        .cornerRadius(5)
                }
                .padding(.bottom, 26)
            }
            
            Button {
                vm.goNext()
            } label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .font(.semiBold14)
                    .foregroundColor(vm.canGoNext ? .white : .gray2)
                    .background(vm.canGoNext ? .mainMint : .gray1)
                    .cornerRadius(5)
            }
            .disabled(!vm.canGoNext)
            .padding(.bottom, 26)
        }
        .padding(.horizontal, 24)
    }
}



#Preview {
    OnBoardingContainerView()
}
