//
//  AIInferenceLoadingView.swift
//  TAMINGO
//
//  Created by Claude on 2/2/26.
//

import SwiftUI

struct AIInferenceLoadingView: View {
    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .mainMint))
                .scaleEffect(0.8)
            
            Text("AI 추론중 ...")
                .font(.regular12)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.subMint, Color.subPink]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.mainMint, lineWidth: 1)
        )
        .cornerRadius(5)
    }
}

#Preview {
    AIInferenceLoadingView()
        .padding()
}
