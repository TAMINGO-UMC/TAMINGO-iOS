//
//  AppRootView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/8/26.
//

import SwiftUI

struct AppRootView: View {

    @State private var isLoggedIn = false
    @State private var didFinishOnboarding = false

    var body: some View {
        Group {
            if !isLoggedIn {
                LoginRootView {
                    isLoggedIn = true
                }
            } else if !didFinishOnboarding {
                OnBoardingContainerView {
                    didFinishOnboarding = true
                }
            } else {
                MainTabContainerView()
            }
        }
    }
}



#Preview {
    AppRootView()
        .environment(SignupProgressStore())
        .environment(SignupSessionStore())
}
