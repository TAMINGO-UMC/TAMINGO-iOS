//
//  ScheduleTodo.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

// MARK: - Todo Connection Component
struct ScheduleTodo: View {
    // Data
    var linkedTodos: [TodoSummaryDTO]     // 선택된(AI 추천) 할 일
    var candidateTodos: [TodoSummaryDTO]  // 선택되지 않은 나머지 할 일
    var isLoading: Bool
    var titleInput: String
    
    // State
    @Binding var isTodoExpanded: Bool
    
    // Actions
    var onToggleTodo: (TodoSummaryDTO) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 헤더 (박스 바깥)
            HStack(spacing: 6) {
                ScheduleSectionHeader(title: "할 일", isRequired: false)
                AIBadge()
            }
            .padding(.bottom, 4)
            
            // 본문
            if isLoading {
                AILoadingRow(text: "할 일 추론중 ...")
            } else if titleInput.isEmpty {
                GuideText(text: "제목 입력 시 AI가 할 일을 추천해 드립니다")
            } else if linkedTodos.isEmpty && candidateTodos.isEmpty {
                GuideText(text: "연결할 할 일이 없습니다")
            } else {
                // MARK: - 메인 컨테이너 박스
                VStack(spacing: 0) {
                    
                    // 선택된 할 일 (Linked Todos)
                    ForEach(Array(linkedTodos.enumerated()), id: \.element.todoId) { index, todo in
                        todoRow(todo: todo, isSelected: true)
                    }
                    
                    // 나머지 후보 할 일 (Candidate Todos) - 확장 시 표시
                    if !candidateTodos.isEmpty && isTodoExpanded {
                        ForEach(Array(candidateTodos.enumerated()), id: \.element.todoId) { index, todo in
                            todoRow(todo: todo, isSelected: false)
                        }
                    }
                    
                    // 하단 버튼
                    if !candidateTodos.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isTodoExpanded.toggle()
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(isTodoExpanded ? "추론된 할 일만 보기" : "할 일 전체보기")
                                Image(systemName: isTodoExpanded ? "chevron.up" : "chevron.down")
                            }
                            .font(.medium12)
                            .foregroundStyle(.gray2)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.white)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                    .padding()
                            )
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray1, lineWidth: 1) // 전체 테두리
                )
            }
        }
    }
    
    // MARK: - 리스트 Row 디자인
    private func todoRow(todo: TodoSummaryDTO, isSelected: Bool) -> some View {
        Button {
            withAnimation(.spring(duration: 0.2)) {
                onToggleTodo(todo)
            }
        } label: {
            HStack(spacing: 12) {
                // 체크박스
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isSelected ? .mainMint : .gray1)
                
                // 텍스트
                Text(todo.title)
                    .font(.medium14)
                    .foregroundStyle(Color.gray2)
                    .lineLimit(1)
                
                Spacer()
                
                // 장소
                if let placeName = todo.placeName {
                    Text(placeName)
                        .font(.medium12)
                        .foregroundStyle(.gray2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.white)
                        .overlay(
                            Capsule()
                                .stroke(.gray1, lineWidth: 1)
                        )
                }
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
