//
//  ScheduleSectionHeader.swift
//  TAMINGO
//
//  Created by 김도연 on 2/2/26.
//

import SwiftUI

// MARK: - Section Header
struct ScheduleSectionHeader: View {
    let title: String
    let isRequired: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Text(title).font(.medium14)
            if isRequired {
                Text("*").font(.medium14).foregroundStyle(Color.mainMint)
            }
        }
    }
}

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

// MARK: - Guide Text
struct AIGuideText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.medium12)
            .foregroundStyle(.gray)
            .padding(.top, 4)
    }
}

// MARK: - Selected Item Row
struct SelectedItemRow: View {
    let title: String
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            Text(title).font(.medium12)
            Spacer()
            Button("수정") { onEdit() }
                .font(.medium12)
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray0)
                .cornerRadius(6)
        }
    }
}
