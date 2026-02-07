//
//  EditCategory.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

// MARK: - Category Component
struct EditCategory: View {
    // State
    var categoryName: String
    
    // Data
    var categories: [ScheduleCategoryDTO]
    
    // Actions
    var onSelectCategory: (ScheduleCategoryDTO) -> Void
    
    // Local State
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                ScheduleSectionHeader(title: "카테고리", isRequired: false)
            }
            
            if isEditing {
                categoryListScroll
            } else {
                SelectedItemRow(title: categoryName) {
                    withAnimation { isEditing = true }
                }
            }
        }
    }
    
    private var categoryListScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories) { category in
                    Button {
                        onSelectCategory(category)
                        withAnimation { isEditing = false }
                    } label: {
                        Text(category.name)
                            .font(.regular12)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                            )
                    }
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
        }
    }
}
