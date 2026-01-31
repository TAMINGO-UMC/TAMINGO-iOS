//
//  AISection.swift
//  TAMINGO
//
//  Created by 김도연 on 1/31/26.
//

import SwiftUI

extension AddScheduleView {
    // MARK: - Place Section (AI)
    var placeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                sectionHeader(title: "장소", isRequired: false)
                aiBadge
            }
            
            if viewModel.isLoading {
                loadingRow(text: "장소 추론중 ...")
            } else if viewModel.title.isEmpty {
                aiGuideText(text: "제목 입력 시 AI가 장소를 추론합니다")
            } else if editPlace {
                // 추천 장소 리스트
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.myPlaces) { place in
                            placeSelectionButton(place: place)
                        }
                    }
                }
            } else {
                selectedItemRow(title: viewModel.placeName) {
                    editPlace.toggle()
                    viewModel.isFavoriteRecommendation = false
                }
            }
        }
    }
    
    private func placeSelectionButton(place: MyPlaceDTO) -> some View {
        Button {
            viewModel.selectPlace(place)
            editPlace.toggle()
        } label: {
            Text(place.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.mainMint)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule().foregroundStyle(Color.mainMint.opacity(0.1))
                )
        }
    }
    
    // MARK: - Todo Connection Section (AI)
    var todoConnectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                sectionHeader(title: "할 일 연결", isRequired: false)
                aiBadge
            }
            
            if viewModel.isLoading {
                loadingRow(text: "할 일 추론중 ...")
            } else if viewModel.title.isEmpty {
                aiGuideText(text: "제목 입력 시 AI가 연관 할 일을 추론합니다")
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
                if !viewModel.linkedTodoIds.isEmpty {
                    ForEach(viewModel.selectedTodoObjects, id: \.todoId) { todo in
                        todoRow(todo: todo, isSelected: true)
                    }
                    expandCollapseButton(isExpanded: viewModel.isTodoExpanded) {
                        withAnimation {
                            viewModel.isTodoExpanded.toggle()
                            viewModel.linkedTodoIds.removeAll() // 전체 해제 로직
                        }
                    }
                } else {
                    // 2. Nearby & Candidate Todos
                    ForEach(viewModel.nearbyTodos, id: \.todoId) { todo in
                        todoRow(todo: todo, isSelected: false)
                    }
                    
                    if viewModel.isTodoExpanded {
                        ForEach(viewModel.candidateTodos, id: \.todoId) { todo in
                            todoRow(todo: todo, isSelected: false)
                        }
                    }
                    
                    if !viewModel.candidateTodos.isEmpty {
                        expandCollapseButton(isExpanded: viewModel.isTodoExpanded) {
                            withAnimation { viewModel.isTodoExpanded.toggle() }
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
                viewModel.toggleTodoSelection(todo.todoId)
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
    
    // MARK: - Category Section (AI)
    var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                sectionHeader(title: "카테고리", isRequired: false)
                aiBadge
            }
            
            if viewModel.isLoading {
                loadingRow(text: "카테고리 추론중 ...")
            } else if viewModel.title.isEmpty {
                Text("제목 입력 시 AI가 카테고리를 추론합니다")
                    .font(.medium12)
                    .foregroundStyle(.gray)
                    .padding(.top, 4)
            }  else if editCategory {
                // 추천 장소 리스트
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.categories) { category in
                            categorySelectionButton(category: category)
                        }
                    }
                }
            } else {
                selectedItemRow(title: viewModel.categoryName) {
                    editCategory.toggle()
                }
            }
        }
    }
    
    private func categorySelectionButton(category: ScheduleCategoryDTO) -> some View {
        Button {
            viewModel.selectCategory(category)
            editCategory.toggle()
        } label: {
            Text(category.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(hex: category.colorCode))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .foregroundStyle(Color(hex: category.colorCode).opacity(0.1))
                )
        }
    }
}
