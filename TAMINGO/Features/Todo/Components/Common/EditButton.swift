//
//  EditButton.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//
import SwiftUI
// MARK: - Edit Button
struct EditButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("수정")
                .font(.medium14)
                .foregroundColor(.gray2)
                .frame(width: 45, height: 26)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray1, lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 6.89, x: 0, y: 2.3)
        }
    }
}
