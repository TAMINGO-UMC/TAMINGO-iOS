//
//  MainView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()

    var body: some View {
        VStack(alignment: .leading) {

            TodayHeaderView()

            VStack(spacing: 17) {

                if let highlighted = viewModel.highlightedSchedule {
                    HighlightScheduleCardView(schedule: highlighted)
                }

                ForEach(viewModel.normalSchedules) { schedule in
                    ScheduleCardView(schedule: schedule)
                }
            }
            .padding(.vertical, 22)
            .padding(.horizontal, 12)
            .frame(minHeight: 536, alignment: .top)
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(
                        color: Color.black.opacity(0.09),
                        radius: 6.89,
                        x: 0,
                        y: 2.297
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.top, 32)
    }
}

#Preview {
    MainView()
}
