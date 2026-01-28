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
            .background(.white)
            .cornerRadius(5)
            .shadow(
                color: Color.black.opacity(0.06),
                radius: 4,
                x: 1,
                y: 1.5
            )
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyleModifier())
    }
}
