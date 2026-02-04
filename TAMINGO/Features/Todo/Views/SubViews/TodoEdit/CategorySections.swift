//
//  CategorySection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct CategorySections: View {
    let isCategoryAIGenerated: Bool
    
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
            }
            
            Text("제목 입력 시 AI가 카테고리를 추론합니다")
                .font(.regular10)
                .foregroundColor(.gray2)
        }
    }
}
