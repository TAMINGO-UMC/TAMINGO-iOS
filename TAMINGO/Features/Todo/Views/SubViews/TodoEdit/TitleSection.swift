//
//  TitleSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct TitleSection: View {
    @Binding var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("제목")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                Text("*")
                    .foregroundColor(.mainMint)
            }
            
            TextField("할 일 제목을 입력하세요", text: $title)
                .font(.medium12)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .padding(.horizontal, 12)
                .background(Color.gray0)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(red: 254/255, green: 254/255, blue: 254/255, opacity: 0.1), lineWidth: 1)
                )
        }
    }
}
