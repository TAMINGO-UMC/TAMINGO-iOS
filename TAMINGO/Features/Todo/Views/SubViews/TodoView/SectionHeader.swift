//
//  SectionHeader.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//
import SwiftUI
struct SectionHeaderComponent: View {
    let title: String
    let date: String?
    let count: Int
    
    init(title: String, date: String? = nil, count: Int) {
        self.title = title
        self.date = date
        self.count = count
    }
    
    var body: some View {
        HStack() {
            Text(title)
                .font(.regular10)
                .foregroundColor(.gray2)
            
            
            if let date = date {
                Text(date)
                    .font(.regular10)
                    .foregroundColor(.gray2)
            }
            
            Spacer()
            
            Text("\(count)개")
                .font(.regular10)
                .foregroundColor(.mainMint)
        }
        .frame(width: 332.85, height: 17)
    }
}
