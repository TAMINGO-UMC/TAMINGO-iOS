//
//  TodayHeaderView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct TodayHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 7.5) {
            Text("오늘")
                .font(.bold22)

            Text("12월 4일 화요일")
                .font(.medium14)
                .foregroundStyle(.gray2)
        }
        .padding(.bottom, 22)
        .padding(.horizontal, 15)
    }
}
