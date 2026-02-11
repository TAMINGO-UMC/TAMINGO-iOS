//
//  ScheduleDeleteButton.swift
//  TAMINGO
//
//  Created by 김도연 on 2/12/26.
//

import SwiftUI

struct ScheduleDeleteButton: View {
    var onDelete: () -> Void
    
    var body: some View {
        Button {
            onDelete()
        } label: {
            Text("일정 삭제")
                .font(.medium14)
                .foregroundStyle(.mainPink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.subPink)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.mainPink, lineWidth: 1)
                        )
                )
        }
    }
}
