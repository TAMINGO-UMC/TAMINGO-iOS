//
//  AIComponent.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

// MARK: - AI Badge
struct AIBadge: View {
    var body: some View {
        Text("AI 추론")
            .font(.regular10)
            .foregroundStyle(Color.mainMint)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .foregroundStyle(.subMint)
            )
    }
}

// MARK: - Loading Row
struct AILoadingRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            ProgressView().tint(Color.mainMint).scaleEffect(0.8)
            Text(text).font(.medium12).foregroundStyle(.black)
        }
        .padding(.top, 4)
    }
}
