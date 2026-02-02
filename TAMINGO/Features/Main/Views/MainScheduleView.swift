//
//  ScheduleView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/27/26.
//

import SwiftUI

struct MainScheduleView: View {

    @State private var viewModel = HomeScheduleViewModel()

    var body: some View {
        VStack(alignment: .leading) {

            TodayHeaderView()

            VStack(spacing: 17) {
                ForEach(viewModel.timelineItems) { item in
                    switch item {

                    case .schedule(let schedule):
                        ScheduleCardView(
                            schedule: schedule,
                            state: schedule.isNextSchedule ? .next : .upcoming,
                            isExpanded: viewModel.expandedScheduleId == schedule.id,
                            onChevronTap: {
                                viewModel.toggleDepartureCard(for: schedule)
                            }
                        )

                    case .gap(let gap):
                        GapTimeCardView(
                            gapTime: gap,
                            onAssignTap: {
                                viewModel.acceptGap(gap)
                            },
                            onLaterTap: {
                                viewModel.rejectGap(gap)
                            }
                        )
                    }
                }
            }
            .padding(.vertical, 22)

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.top, 32)
    }
}

#Preview {
    MainScheduleView()
}
