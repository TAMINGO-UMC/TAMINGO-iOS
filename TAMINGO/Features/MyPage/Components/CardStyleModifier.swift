//
//  CardStyleModifier.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI

struct CardStyleModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(
                color: Color.black.opacity(0.06),
                radius: 6.89,
                x: 0,
                y: 2.3
            )
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyleModifier())
    }
}
