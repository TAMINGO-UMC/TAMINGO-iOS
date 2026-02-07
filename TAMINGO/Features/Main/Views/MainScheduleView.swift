//
//  MainScheduleView.swift
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

            ScrollView {
                VStack(spacing: 17) {
                    let items: [HomeTimelineItem] = Array(viewModel.timelineItems)

                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        switch item {
                        case .schedule(let schedule):
                            ScheduleCardView(
                                schedule: schedule,
                                state: schedule.isNextSchedule ? .next : .upcoming,
                                isExpanded: viewModel.expandedScheduleId == schedule.id,
                                detailVM: viewModel.scheduleDetailVMs[schedule.id],
                                onChevronTap: { viewModel.toggleDepartureCard(for: schedule, accessToken: "ACCESS_TOKEN") }
                            )

                        case .gap(let gap):
                            GapTimeCardView(
                                gapTime: gap,
                                onAssignTap: { viewModel.acceptGap(gap) },
                                onLaterTap: { viewModel.rejectGap(gap) }
                            )
                        }
                    }

                }
                .padding(.top, 22)
                .padding(.bottom, 40)
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 32)
        .onAppear {
            viewModel.loadToday(
                accessToken: "ACCESS_TOKEN"
            )
        }
    }
}

#Preview {
    MainScheduleView()
}

