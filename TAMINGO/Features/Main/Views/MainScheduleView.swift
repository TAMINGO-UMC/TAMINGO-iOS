//
//  MainScheduleView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/27/26.
//

import SwiftUI
import CoreLocation

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
                                let isExpanded = viewModel.expandedScheduleId == schedule.id
                                let detailVM = viewModel.detailViewModel(for: schedule.id)
                                let isArrived = viewModel.arrivedScheduleIds.contains(schedule.id)
                                
                                ScheduleCardView(
                                    schedule: schedule,
                                    state: state,
                                    isExpanded: isExpanded,
                                    isArrived: isArrived,
                                    onChevronTap: {
                                        viewModel.toggleDepartureCard(for: schedule)
                                    },
                                    onRouteStart: { id in
                                        selectedScheduleId = id
                                        isRouteGuideActive = true
                                    },
                                    detailVM: detailVM
                                )
                                .onChange(of: isExpanded) { _, newValue in
                                    if newValue {
                                        detailVM.startLiveRefresh()
                                    } else {
                                        detailVM.stopLiveRefresh()
                                    }
                                }
                                
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
                    let detailVM = viewModel.detailViewModel(for: id)

                    RouteFindViewWrapper(
                        scheduleId: id,
                        detailViewModel: detailVM
                    )
                }
            }

            .onReceive(NotificationCenter.default.publisher(for: .routeDidEnd)) { _ in
                viewModel.loadToday()
            }
        }
    }
}

struct RouteFindViewWrapper: View {
    let scheduleId: Int
    let detailViewModel: ScheduleDetailViewModel

    @State private var coord: CLLocationCoordinate2D?

    var body: some View {
        Group {
            if let coord {
                RouteFindView(
                    scheduleId: scheduleId,
                    detailViewModel: detailViewModel,
                    currentLatitude: coord.latitude,
                    currentLongitude: coord.longitude
                )
            } else {
                ProgressView("위치 확인 중…")
                    .task {
                        do {
                            coord = try await LocationManager
                                .shared
                                .requestCurrentCoordinate()
                        } catch {
                            coord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                        }
                    }
            }
        }
    }
}


#Preview {
    MainScheduleView()
}

