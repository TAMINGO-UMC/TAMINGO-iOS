//
//  TodoRowComponent.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//
import SwiftUI

struct TodoRow: View {
    let item: TodoItem
    let onToggle: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // MARK: - 완료 영역
            // isCompleted == false → 빈 체크박스 (테두리만)
            // isCompleted == true  → 채워진 체크박스 (체크표시 포함)
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(item.isCompleted ? .mainMint : .gray1)
                    .frame(width: 20, height: 20)
            }
            
            Text(item.title)
                .font(.medium12)
                .foregroundColor(item.isCompleted ? .gray2 : .black)
                .strikethrough(item.isCompleted)
            
            CategoryTag(category: item.category, categoryColor: item.categoryColor)
            
            Spacer()
            
            Button(action: onEdit) {
                Text("편집")
                    .font(.regular10)
                    .foregroundColor(.gray2)
            }
        }
        .frame(width: 333, height: 41.03)
        .padding(.horizontal, 12)
    }
}
