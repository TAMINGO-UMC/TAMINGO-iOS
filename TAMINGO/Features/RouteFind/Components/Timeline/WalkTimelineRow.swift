//
//  WalkTimelineRow.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct WalkTimelineRow: View {

    let text: String
    let isFirst: Bool
    let isLast: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 10) {

            TimelineVerticalLineView(
                node: .walk(.gray1),
                above: .dashed(.gray1),
                below: .dashed(.gray1)
            )

            Text(text)
                .font(.medium12)
                .foregroundStyle(.gray2)
                .padding(.vertical, 20)

            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

