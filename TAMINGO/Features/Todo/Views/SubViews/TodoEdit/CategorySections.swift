//
//  CategorySection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//  Updated: 2/9/26 - 수정 버튼 및 확장/축소 UI 추가
//

import SwiftUI

struct CategorySections: View {
    @Binding var viewModel: TodoEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("카테고리")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                if viewModel.isCategoryAIGenerated {
                    AIBadge()
                }
                
                Spacer()
                
                // AI 추론 중 로딩 표시
                if viewModel.isInferringCategory {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            if !viewModel.isCategoryExpanded {
                collapsedView
            }
            
            if viewModel.isCategoryExpanded {
                expandedView
            }
        }
    }
    
    // MARK: - Collapsed View
    private var collapsedView: some View {
        HStack(spacing: 8) {
            Text(viewModel.category.isEmpty ? "카테고리를 선택하세요" : viewModel.category)
                .font(.medium14)
                .foregroundColor(viewModel.category.isEmpty ? .gray2 : .black)
            
            Spacer()
            
            EditButton(action: {
                // ✅ 확장 시 카테고리 목록 조회
                Task {
                    await viewModel.loadCategories()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        viewModel.isCategoryExpanded = true
                    }
                }
            })
            
            if !viewModel.category.isEmpty {
                DeleteButton(action: {
                    viewModel.category = ""
                    viewModel.isCategoryAIGenerated = false
                })
            }
        }
        .onTapGesture {
            // ✅ 탭 시에도 카테고리 목록 조회
            Task {
                await viewModel.loadCategories()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    viewModel.isCategoryExpanded = true
                }
            }
        }
    }
    
    // MARK: - Expanded View
    private var expandedView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // AI 추론 완료 전 안내 텍스트
            if viewModel.isCategoryAIGenerated && !viewModel.isInferringCategory {
                Text("이 할 일과 관련된 일정을 선택하세요")
                    .font(.regular10)
                    .foregroundColor(.gray2)
            }
            
            // 카테고리 목록 (좌우 스크롤)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.availableCategories, id: \.self) { category in
                        CategoryButton(
                            category: category,
                            isSelected: viewModel.category == category
                        ) {
                            viewModel.category = category
                            viewModel.isCategoryAIGenerated = false
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                viewModel.isCategoryExpanded = false
                            }
                        }
                    }
                }
            }
            
            // 취소 버튼
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    viewModel.isCategoryExpanded = false
                }
            }) {
                Text("취소")
                    .font(.medium12)
                    .foregroundColor(.gray2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(Color.gray0)
                    .cornerRadius(6)
            }
        }
        .padding(16)
        .background(Color.gray0.opacity(0.5))
        .cornerRadius(8)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

// MARK: - CategoryButton
struct CategoryButton: View {
    let category: String
    let isSelected: Bool
    let action: () -> Void
    
    private var categoryColor: Color {
        switch category {
        case "일상": return Color(hex: "#22C7A9")
        case "생활": return Color(hex: "#A7E0D8")
        case "업무": return Color(hex: "#FFC576")
        case "먹기": return Color(hex: "#FFD3B6")
        default: return Color(hex: "#22C7A9")
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(category)
                .font(.regular12)
                .foregroundColor(isSelected ? .white : categoryColor)
                .padding(.horizontal, 12)
                .frame(height: 32)
                .background(isSelected ? categoryColor : categoryColor.opacity(0.15))
                .cornerRadius(8)
        }
    }
}
