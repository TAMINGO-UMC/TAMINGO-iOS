//
//  TimelineStartRow.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/10/26.
//

import SwiftUI

struct TimelineStartRow: View {

    let startPlaceName: String
    let isFirst: Bool   // 시작이면 true

    var body: some View {
        HStack(alignment: .center, spacing: 10) {

            TimelineVerticalLineView(
                node: .start(.mainMint),
                above: isFirst ? .none : .dashed(.gray1),
                below: .dashed(.gray1)
            )

            Text(startPlaceName)
                .font(.semiBold14)
                .foregroundStyle(.black00)
                .padding(.vertical, 20)

            Spacer()
        }
        .padding(.horizontal, 40)
    }
}
