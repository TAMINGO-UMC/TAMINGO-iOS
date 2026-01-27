//
//  ScheduleView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/27/26.
//

import SwiftUI

struct MainScheduleView: View {

    @State private var viewModel =
        HomeScheduleViewModel(schedules: Schedule.mockToday)

    var body: some View {
        VStack(alignment: .leading) {

            TodayHeaderView()

            VStack(spacing: 17) {
                ForEach(viewModel.schedules) { schedule in

                    ScheduleCardView(
                        schedule: schedule,
                        state: schedule.isHighlighted ? .next : .upcoming,
                        isExpanded: viewModel.expandedScheduleId == schedule.id,
                        onChevronTap: {
                            viewModel.toggleDepartureCard(for: schedule)
                        }
                    )
                }
            }
            .padding(.vertical, 22)

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.top, 32)
        .animation(.easeOut, value: viewModel.expandedScheduleId)
    }
}

#Preview {
    MainScheduleView()
}
