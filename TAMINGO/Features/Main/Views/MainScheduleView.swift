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
//                    let items: [HomeTimelineItem] = Array(viewModel.timelineItems)
                    
                    ForEach(viewModel.timelineItems) { item in
                        switch item {
                            
                        case .schedule(let schedule):
                            
                            let state = viewModel.scheduleState(for: schedule)
                            
                            
                            ScheduleCardView(
                                schedule: schedule,
                                state: state,
                                isExpanded: viewModel.expandedScheduleId == schedule.id,
                                detailVM: viewModel.detailViewModel(for: schedule.id),
                                onChevronTap: {
                                    print("🔥 forced toggle")
                                    viewModel.toggleDepartureCard(for: schedule)
                                }
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
            viewModel.loadToday()
        }
    }
}

#Preview {
    MainScheduleView()
}

