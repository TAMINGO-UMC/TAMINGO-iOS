//
//  SchedulePlaceView.swift
//  TAMINGO
//
//  Created by 김도연 on 2/2/26.
//

import SwiftUI

// MARK: - Place Component
struct SchedulePlaceView: View {
    // State
    var isLoading: Bool
    var titleInput: String
    var placeName: String
    
    // Data
    var myPlaces: [MyPlaceDTO]
    
    // Actions
    var onSelectPlace: (MyPlaceDTO) -> Void
    var onResetFavoriteRecommendation: () -> Void
    
    // Local State (내부적으로 관리)
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                ScheduleSectionHeader(title: "장소", isRequired: false)
                AIBadge()
            }
            
            if isLoading {
                AILoadingRow(text: "장소 추론중 ...")
            } else if titleInput.isEmpty {
                AIGuideText(text: "제목 입력 시 AI가 장소를 추론합니다")
            } else if isEditing {
                placeListScroll
            } else {
                SelectedItemRow(title: placeName) {
                    withAnimation {
                        isEditing = true
                        onResetFavoriteRecommendation()
                    }
                }
            }
        }
    }
    
    private var placeListScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(myPlaces) { place in
                    Button {
                        onSelectPlace(place)
                        withAnimation { isEditing = false }
                    } label: {
                        Text(place.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.mainMint)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Capsule().foregroundStyle(Color.mainMint.opacity(0.1)))
                    }
                }
            }
        }
    }
}

// MARK: - Category Component
struct ScheduleCategoryView: View {
    // State
    var isLoading: Bool
    var titleInput: String
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
                AIBadge()
            }
            
            if isLoading {
                AILoadingRow(text: "카테고리 추론중 ...")
            } else if titleInput.isEmpty {
                AIGuideText(text: "제목 입력 시 AI가 카테고리를 추론합니다")
            } else if isEditing {
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
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color(hex: category.colorCode))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().foregroundStyle(Color(hex: category.colorCode).opacity(0.1))
                            )
                    }
                }
            }
        }
    }
}

// MARK: - Todo Connection Component
struct ScheduleTodoConnectionView: View {
    // State
    var isLoading: Bool
    var titleInput: String
    
    // Data
    var linkedTodoIds: [Int]
    var selectedTodoObjects: [TodoSummaryDTO]
    var nearbyTodos: [TodoSummaryDTO]
    var candidateTodos: [TodoSummaryDTO]
    @Binding var isTodoExpanded: Bool // 뷰모델 상태를 변경해야 하므로 Binding
    
    // Actions
    var onToggleTodo: (Int) -> Void
    var onClearTodos: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                ScheduleSectionHeader(title: "할 일 연결", isRequired: false)
                AIBadge()
            }
            
            if isLoading {
                AILoadingRow(text: "할 일 추론중 ...")
            } else if titleInput.isEmpty {
                AIGuideText(text: "제목 입력 시 AI가 연관 할 일을 추론합니다")
            } else {
                todoListContainer
            }
        }
    }
    
    private var todoListContainer: some View {
        VStack(spacing: 0) {
            Text("이 일정과 관련된 할 일을 선택하세요")
                .font(.medium12)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            VStack(alignment: .leading, spacing: 0) {
                // 1. 선택된 할 일들
                if !linkedTodoIds.isEmpty {
                    ForEach(selectedTodoObjects, id: \.todoId) { todo in
                        todoRow(todo: todo, isSelected: true)
                    }
                    expandCollapseButton(isExpanded: isTodoExpanded) {
                        withAnimation {
                            isTodoExpanded.toggle()
                            onClearTodos()
                        }
                    }
                } else {
                    // 2. 추천 및 후보 할 일들
                    ForEach(nearbyTodos, id: \.todoId) { todo in
                        todoRow(todo: todo, isSelected: false)
                    }
                    
                    if isTodoExpanded {
                        ForEach(candidateTodos, id: \.todoId) { todo in
                            todoRow(todo: todo, isSelected: false)
                        }
                    }
                    
                    if !candidateTodos.isEmpty {
                        expandCollapseButton(isExpanded: isTodoExpanded) {
                            withAnimation { isTodoExpanded.toggle() }
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray1, lineWidth: 1)
            )
        }
    }
    
    private func todoRow(todo: TodoSummaryDTO, isSelected: Bool) -> some View {
        Button {
            withAnimation {
                onToggleTodo(todo.todoId)
            }
        } label: {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isSelected ? Color.mainMint : Color.gray2)
                
                Text(todo.title)
                    .font(.medium14)
                    .foregroundStyle(Color.gray2)
                
                Spacer()
                
                if let placeName = todo.placeName {
                    Text(placeName)
                        .font(.medium12)
                        .foregroundStyle(.gray2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .overlay(Capsule().stroke(Color.gray1, lineWidth: 1))
                }
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }
    
    private func expandCollapseButton(isExpanded: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(isExpanded ? "추론된 할 일만 보기" : "할 일 전체보기")
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .font(.medium12)
            .foregroundStyle(Color.gray2)
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
            .padding(.bottom, 4)
        }
    }
}
