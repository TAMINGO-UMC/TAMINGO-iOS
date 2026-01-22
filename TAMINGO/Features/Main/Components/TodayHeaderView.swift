//
//  TodayHeaderView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct TodayHeaderView: View {
    private static let todayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7.5) {
            Text("오늘")
                .font(.bold22)

            Text(Self.todayFormatter.string(from: Date()))
                .font(.medium14)
                .foregroundStyle(.gray2)
        }
        .padding(.bottom, 22)
        .padding(.horizontal, 15)
    }
}
