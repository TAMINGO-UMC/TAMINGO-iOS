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
                
                AIBadge()
                
                Spacer()
                
                // ✅ [삭제] 기존 헤더 쪽 ProgressView 제거 (아래 AILoadingRow로 대체)
            }
            
            // ✅ [수정] AI 추론 중일 때 로딩 UI 표시
            if viewModel.isInferringCategory {
                AILoadingRow(text: "카테고리 추론중 ...")
            } else {
                // 기존 로직 유지
                if !viewModel.isCategoryExpanded {
                    collapsedView
                }
                
                if viewModel.isCategoryExpanded {
                    expandedView
                }
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
                    ForEach(viewModel.availableCategories) { category in
                        CategoryButton(category: category) {
                            viewModel.category = category.name
                            viewModel.isCategoryAIGenerated = false
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                viewModel.isCategoryExpanded = false
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 4)
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
    let category: TodoCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
