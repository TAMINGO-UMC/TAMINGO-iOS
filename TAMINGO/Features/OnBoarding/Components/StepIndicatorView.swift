//
//  StepIndicatorView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI

struct StepIndicatorView: View {
    let currentStep: Int
    
    var activeColor: Color = .mainMint
    var inactiveColor: Color = .mint.opacity(0.3)
    
    var body: some View {
        VStack(spacing: 5) {
            Circle()
                .fill(activeColor)
                .frame(width: 16, height: 16)
                .overlay(
                    Text("\(currentStep)")
                        .font(.regular09) // TODO: regular10 변경 필요
                        .foregroundColor(.white)
                )
            DottedGradientLineView()
        }
    }
}

struct DottedGradientLineView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 1, y: 0))
            path.addLine(to: CGPoint(x: 1, y: 24))
        }
        .stroke(
            LinearGradient(
                colors: [
                    .mainMint,
                    .subMint
                ],
                startPoint: .top,
                endPoint: .bottom
            ),
            style: StrokeStyle(
                lineWidth: 2,
                lineCap: .round,
                dash: [1, 4]
            )
        )
        .frame(width: 2, height: 24)
    }
}





#Preview {
    StepIndicatorView(currentStep: 1)
}
