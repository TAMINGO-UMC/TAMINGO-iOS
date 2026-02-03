//
//  BottomButtons.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct BottomButtons: View {
    @Binding var viewModel: TodoEditViewModel
    @Binding var item: TodoItem
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // 할일 삭제 버튼
            Button(action: {
                // 삭제 로직
                isPresented = false
            }) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(.mainPink)
                    
                    Text("할 일 삭제")
                        .font(.medium14)
                        .foregroundColor(.mainPink)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray1, lineWidth: 1)
                )
            }
            
            HStack(spacing: 12) {
                // 취소 버튼
                Button(action: {
                    isPresented = false
                }) {
                    Text("취소")
                        .font(.medium14)
                        .foregroundColor(.gray2)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray1, lineWidth: 1)
                        )
                }
                
                // 저장 버튼
                Button(action: {
                    viewModel.saveChanges(to: &item)
                    isPresented = false
                }) {
                    Text("저장")
                        .font(.medium14)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.mainMint))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.bottom, 30)
    }
}
