//
//  PageIndicatorView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI


struct PageIndicatorView: View {
    let currentPage: Int
    let totalPages: Int

    var activeColor: Color = .mainMint
    var inactiveColor: Color = .white

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .overlay(
                        Circle()
                            .stroke(.mainMint, lineWidth:1)
                    )
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
}

#Preview {
    PageIndicatorView(currentPage: 1, totalPages: 5)
}
