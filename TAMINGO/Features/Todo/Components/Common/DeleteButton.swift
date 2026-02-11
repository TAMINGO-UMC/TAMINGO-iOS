//
//  DeleteButton.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//
import SwiftUI
// MARK: - Delete Button
struct DeleteButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("삭제")
                .font(.medium14)
                .foregroundColor(.mainPink)
                .frame(width: 45, height: 26)
                .background(Color.subPink)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray1, lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 6.89, x: 0, y: 2.3)
        }
    }
}
