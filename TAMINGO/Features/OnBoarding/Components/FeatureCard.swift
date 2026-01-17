//
//  FeatureCard.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI

struct FeatureCard: View {

    // MARK: - Inputs
    let icon: Image
    let title: String
    let text: String
    let highlights: [String]   // 강조할 문구들만 전달

    // MARK: - Body
    var body: some View {
        HStack(spacing: 14) {
            iconBadge

            VStack(alignment: .leading, spacing: 3.54) {
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.black)

                Text(attributedText)
                    .font(.system(size: 8))
                    .foregroundStyle(.gray2)
            }
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 15)
        .frame(width: 300, alignment: .leading)
        .background(cardBackground)
        
    }
}

// MARK: - Subviews
private extension FeatureCard {

    /// 아이콘 배지 (모든 카드 동일)
    var iconBadge: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.mainMint)
                .frame(width: 40, height: 40)

            icon
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
        }
    }

    // 카드 배경
    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: [ // 그라데이션에만 사용되는 색상이라 등록 안하고 사용
                        Color(
                            red: 183/255,
                            green: 240/255,
                            blue: 230/255,
                            opacity: 0.145
                        ),
                        Color(
                            red: 183/255,
                            green: 240/255,
                            blue: 230/255,
                            opacity: 0.063
                        )
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(
                color: .black.opacity(0.10),
                radius: 6.207,
                x: 0,
                y: 2.069
            )
    }

    // 강조 처리 텍스트
    var attributedText: AttributedString {
        var attributed = AttributedString(text)

        for highlight in highlights {
            if let range = attributed.range(of: highlight) {
                attributed[range].foregroundColor = .mainMint
                attributed[range].font = .system(size: 8, weight: .semibold)
            }
        }

        return attributed
    }
}


#Preview {
    FeatureCard(
        icon: Image("OnBoarding_icon_time"),
        title: "하루 일과 보드 제공",
        text: "일정, To-do, 이동 시간이 모두 정리된 오늘의 일과 보드를 제공해요",
        highlights: ["오늘의 일과 보드"]
    )
    .padding()
}

