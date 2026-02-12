//
//  CategoryTag.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//

import SwiftUI

struct CategoryTag: View {
    let category: String
    let categoryColor: Color
    
    var body: some View {
        Text(category)
            .font(.regular10)
            .foregroundColor(categoryColor.opacity(0.8))
            .frame(width: 32, height: 17)
            .background(categoryColor.opacity(0.15))
            .cornerRadius(4)
    }
}

#Preview {
    HStack(spacing: 8) {
        CategoryTag(category: "일상", categoryColor: Color(hex: "#22C7A9"))
        CategoryTag(category: "생활", categoryColor: Color(hex: "#A7E0D8"))
        CategoryTag(category: "업무", categoryColor: Color(hex: "#FFC576"))
    }
    .padding()
}
