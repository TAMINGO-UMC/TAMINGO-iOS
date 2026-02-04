//
//  CardStyleModifier.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI

// 메인페이지 카드 스타일
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

// 카테고리 카드 스타일
struct CategoryStyleModifier: ViewModifier {
    
    let height: CGFloat
    let color: Color
    
    func body(content: Content) -> some View {
        HStack{
            RoundedRectangle(cornerRadius: 14)
                .fill(color)
                .frame(width: 5, height:height)
            content
                .padding(16)
                .frame(height: height, alignment: .center)
                .background(.white)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.06), radius: 3.44483, x: 0, y: 2.29655)
        }
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyleModifier())
    }
}

extension View {
    func categotyStyle(height: CGFloat, color: Color) -> some View {
        self.modifier(CategoryStyleModifier(height:height, color:color))
    }
}
