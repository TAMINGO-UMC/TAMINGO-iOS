//
//  TodoRow.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//  Updated: 2/9/26 - 관련 스케줄 표시 추가
//

import SwiftUI

struct TodoRow: View {
    let item: TodoItem
    let onToggle: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // MARK: - 완료 영역 (카테고리 색상 적용)
            Button(action: onToggle) {
                ZStack {
                    if item.isCompleted {
                        // 완료 시: 카테고리 색상으로 채워진 박스 + 흰색 체크마크
                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.categoryColor)
                            .frame(width: 20, height: 20)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        // 미완료: 회색 테두리만
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray1, lineWidth: 1.5)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            
            // 제목 (완료 여부와 관계없이 동일한 스타일)
            Text(item.title)
                .font(.medium12)
                .foregroundColor(.black)
            
            CategoryTag(category: item.category, categoryColor: item.categoryColor)
            
            Spacer()
            
            Button(action: onEdit) {
                Text("편집")
                    .font(.regular10)
                    .foregroundColor(.gray2)
            }
        }
        .frame(width: 333)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
