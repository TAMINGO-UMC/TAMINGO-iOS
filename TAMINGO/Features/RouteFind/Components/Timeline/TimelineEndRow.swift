//
//  TimelineEndRow.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/10/26.
//

import SwiftUI

struct TimelineEndRow: View {

    let title: String
    let isLast: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            TimelineVerticalLineView(
                node: .end(.mainPink),
                above: .dashed(.gray1),
                below: isLast ? .none : .dashed(.gray1)
            )

            Text(title)
                .font(.semiBold14)
                .foregroundStyle(.black00)
                .padding(.vertical, 20)

            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

