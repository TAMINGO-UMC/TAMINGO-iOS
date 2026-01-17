//
//  OnBoardingHeaderView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import SwiftUI

struct OnboardingHeaderView: View {
    let title: String
    let subtitle: OnboardingSubtitle

    var body: some View {
        VStack(spacing: 9) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            switch subtitle {
            case .text(let text):
                Text(text)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

            case .image(let name):
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)

            case .none:
                EmptyView()
            }
        }
    }
}


