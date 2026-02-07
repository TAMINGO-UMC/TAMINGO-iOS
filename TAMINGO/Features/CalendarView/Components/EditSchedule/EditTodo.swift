//
//  EditTodo.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

// MARK: - Todo Component
struct EditTodo: View {
    // Data
    var linkedTodos: [TodoSummaryDTO]
    var candidateTodos: [TodoSummaryDTO]
    @Binding var isTodoExpanded: Bool // 뷰모델 상태를 변경해야 하므로 Binding
    
    // Actions
    var onToggleTodo: (TodoSummaryDTO) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                ScheduleSectionHeader(title: "할 일 연결", isRequired: false)
            }
        }
        .padding(.bottom, 4)
        
        VStack(spacing: 0) {
            Text("이 일정과 관련된 할 일을 선택하세요")
                .font(.medium12)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            VStack(alignment: .leading, spacing: 0) {
                // 선택된 할 일들
                ForEach(linkedTodos, id: \.todoId) { todo in
                    todoRow(todo: todo, isSelected: true)
                }
                if isTodoExpanded {
                    ForEach(candidateTodos, id: \.todoId) { todo in
                        todoRow(todo: todo, isSelected: false)
                    }
                }
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isTodoExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(isTodoExpanded ? "선택된 할 일만 보기" : "할 일 전체보기")
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
            .background(
                RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray1, lineWidth: 1) // 전체 테두리
            )
        }
    }
    
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
