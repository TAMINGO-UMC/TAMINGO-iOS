//
//  MyPageHeader.swift
//  TAMINGO
//
//  Created by 김도연 on 2/9/26.
//

import SwiftUI

struct MyPageHeader: View {
    @Environment(\.dismiss) var dismiss
    var title: String
    
    var body: some View {
        HStack(spacing: 14){
            Button {
                dismiss()
            } label: {
                Image("Previous_Chevron")
                    .resizable()
                    .frame(width: 5, height: 10)
            }
            
            Text(title)
                .font(.semiBold16)
                .foregroundStyle(.black00)
        }
    }
}
