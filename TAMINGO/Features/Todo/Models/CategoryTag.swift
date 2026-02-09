//
//  CategoryTag.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: CategoryColor enum 사용
//

import SwiftUI

struct CategoryTag: View {
    let category: String
    let categoryColor: CategoryColor
    
    var body: some View {
        Text(category)
            .font(.regular10)
            .foregroundColor(categoryColor.color.opacity(0.8))
            .frame(width: 32, height: 17)
            .background(categoryColor.color.opacity(0.15))
            .cornerRadius(4)
    }
}

#Preview {
    HStack(spacing: 8) {
        CategoryTag(category: "일상", categoryColor: .mint)
        CategoryTag(category: "생활", categoryColor: .lightMint)
        CategoryTag(category: "업무", categoryColor: .peach)
    }
    .padding()
}
