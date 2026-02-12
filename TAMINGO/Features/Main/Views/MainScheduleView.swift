//
//  MainScheduleView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/27/26.
//

import SwiftUI

struct MainScheduleView: View {
    
    @State private var viewModel = HomeScheduleViewModel()
    
    @State private var selectedScheduleId: Int?
    @State private var isRouteGuideActive = false
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
                
                TodayHeaderView()
                
                ScrollView {
                    VStack(spacing: 17) {
                        let items = viewModel.timelineItems
                        
                        ForEach(items, id: \.id) { item in
                            switch item {
                                
                            case .schedule(let schedule):
                                let state = viewModel.scheduleState(for: schedule)
                                
                                ScheduleCardView(
                                    schedule: schedule,
                                    state: state,
                                    isExpanded: viewModel.expandedScheduleId == schedule.id,
                                    onChevronTap: {
                                        viewModel.toggleDepartureCard(for: schedule)
                                    },
                                    onRouteStart: { id in
                                        selectedScheduleId = id
                                        isRouteGuideActive = true
                                    },
                                    detailVM: viewModel.detailViewModel(for: schedule.id)
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
            .navigationDestination(isPresented: $isRouteGuideActive) {
                            if let id = selectedScheduleId {
                                RouteFindView(scheduleId: id)
                            }
                        }
        }
    }
}

#Preview {
    MainScheduleView()
}

