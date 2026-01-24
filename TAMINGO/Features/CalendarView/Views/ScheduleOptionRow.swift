//
//  ScheduleOptionRow.swift
//  TAMINGO
//
//  Created by 김도연 on 1/25/26.
//

import SwiftUI

struct ScheduleOptionRow: View {
    let title: String
    let image: String
    let action: () -> Void
    
    init(title: String, image: String, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.medium12)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Image(systemName: image)
                    .foregroundStyle(.black)
            }
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.gray0))
    }
}
