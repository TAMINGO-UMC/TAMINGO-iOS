//
//  CategorySection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//  Updated: 2/8/26 - AI 로딩 상태 표시
//

import SwiftUI

struct CategorySections: View {
    let isCategoryAIGenerated: Bool
    let isInferring: Bool  // 로딩 상태 추가
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("카테고리")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                if isCategoryAIGenerated {
                    AIBadge()
                }
                
                Spacer()
                
                // AI 추론 중 로딩 표시
                if isInferring {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            // AI 추론 완료 전에만 안내 텍스트 표시
            if isCategoryAIGenerated && !isInferring {
                Text("제목 입력 시 AI가 카테고리를 추론합니다")
                    .font(.regular10)
                    .foregroundColor(.gray2)
            }
        }
    }
}
