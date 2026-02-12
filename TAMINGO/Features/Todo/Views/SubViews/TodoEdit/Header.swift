//
//  Header.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct Header: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            Text("할 일 수정")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray2)
            }
        }
    }
}
