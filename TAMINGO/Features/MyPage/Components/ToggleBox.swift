//
//  ToggleBox.swift
//  TAMINGO
//
//  Created by 김도연 on 2/9/26.
//

import SwiftUI

struct ToggleBox: View {
    let title: String
    let sub: String
    var isPink: Bool = false
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2){
                Text(title)
                    .font(.medium14)
                    .foregroundStyle(.black00)
                Text(sub)
                    .font(.regular12)
                    .foregroundStyle(.gray2)
            }
            
            Spacer()
            
            ToggleButton(isOn: $isOn, isPink: isPink)
        }
        .frame(height:62)
    }
}
