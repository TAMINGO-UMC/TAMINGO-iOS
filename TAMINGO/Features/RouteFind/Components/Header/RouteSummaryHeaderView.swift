//
//  RouteSummaryHeaderView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct RouteSummaryHeaderView: View {

    let route: RouteResultModel

    var body: some View {
        HStack(spacing: 10) {

            Image(systemName: "paperplane.fill")
                .foregroundStyle(Color.mainMint)
                .font(.bold24)

            Text(route.totalMinutesText)
                .foregroundStyle(Color.mainMint)
                .font(.medium24)

            Text("\(route.startTimeText) - \(route.endTimeText)")
                .font(.medium14)
                .foregroundStyle(.gray2)

            Spacer()
        }
        .padding(.horizontal, 35)
        .padding(.top, 7)
        .padding(.bottom, 15)
    }
}
