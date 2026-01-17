//
//  IntroContainerView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI

struct IntroContainerView: View {

    let page: IntroPage  

    var body: some View {
        Group {
            switch page {
            case .overview:
                IntroOverViewSection()

            case .calendar:
                IntroCalenderSection()

            case .flow:
                IntroFlowSection()

            case .permission:
                IntroPermissionSection()
            }
        }
        .frame(width:330, height: 459)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray1, lineWidth: 1)
        )
    }
    
}



#Preview {
    IntroContainerView(page:.permission)
}


