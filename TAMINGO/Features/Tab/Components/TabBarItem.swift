//
//  TabBarItem.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct TabBarItem: View {
    let tab: MainTab
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(isSelected ? Color.mainMint : Color.clear)
                .frame(height: 2)
            
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.regular20)
                    .foregroundStyle(isSelected ? .mainMint : .gray2)
                    .padding(.horizontal, 8)
                
                Text(tab.title)
                    .font(.regular10)
                    .foregroundStyle(isSelected ? .mainMint : .gray2)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
