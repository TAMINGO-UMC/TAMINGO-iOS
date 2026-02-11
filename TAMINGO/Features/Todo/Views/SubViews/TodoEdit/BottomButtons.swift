//
//  BottomButtons.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//  Updated: 2/9/26 - 저장/삭제 콜백 추가
//

import SwiftUI

struct BottomButtons: View {
    @Binding var viewModel: TodoEditViewModel
    @Binding var item: TodoItem
    @Binding var isPresented: Bool
    
    // ✅ 저장/삭제 콜백 추가
    var onSave: ((TodoItem) -> Void)?
    var onDelete: ((TodoItem) -> Void)?
    
    var body: some View {
        VStack(spacing: 12) {
            // 할일 삭제 버튼
            Button(action: {
                // ✅ 삭제 콜백 호출
                onDelete?(item)
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
                    // ✅ 1. ViewModel → Item 반영
                    viewModel.saveChanges(to: &item)
                    
                    // ✅ 2. 저장 콜백 호출 (서버 업데이트)
                    onSave?(item)
                    
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
