//
//  TransportButton.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import SwiftUI

struct RankLabel: View {
    let rank: Int
    let title: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing:4) {
                Text("\(rank)순위")
                    .font(.medium14)
                    .foregroundStyle(.black)
                HStack(spacing: 2.17){
                    Text(title)
                        .font(.medium14)
                        .frame(alignment: .leading)
                        .foregroundStyle(.mainPink)
                    
                    Image("icon_pinkChevron")
                }
                .frame(width: 49)
                
            }
        }
        .buttonStyle(.plain)
    }
}


#Preview("Single RankLabel") {
    RankLabel(
        rank: 1,
        title: "Label",
        onTap: {}
    )
    .padding()
}
