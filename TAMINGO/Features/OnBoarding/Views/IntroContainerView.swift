//
//  IntroContainerView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI

struct IntroContainerView: View {

    @Binding  var vm: OnboardingViewModel
    let page: IntroPage

    var body: some View {
        Group {
            switch page {
            case .overview:
                IntroOverViewSection()

            case .calendar:
                IntroCalenderSection(vm:$vm)

            case .flow:
                IntroFlowSection()

            case .permission:
                IntroPermissionSection(vm:$vm)
            }
        }
        .frame(width:330, height: 459)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray1, lineWidth: 1)
        )
    }
    
}


//
//#Preview {
//    IntroContainerView(page:.permission)
//}
//

