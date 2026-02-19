//
//  RouteFindView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct RouteFindView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    @State private var viewModel: RouteGuideViewModel
    let detailViewModel: ScheduleDetailViewModel

    let currentLatitude: Double
    let currentLongitude: Double

    @State private var isArrivalAlertPresented = false
    @State private var isEndConfirmPresented = false
    


    init(
        scheduleId: Int,
        detailViewModel: ScheduleDetailViewModel,
        currentLatitude: Double,
        currentLongitude: Double
    ) {
        _viewModel = State(initialValue: RouteGuideViewModel(scheduleId: scheduleId))
        self.detailViewModel = detailViewModel
        self.currentLatitude = currentLatitude
        self.currentLongitude = currentLongitude
    }

    var body: some View {
        VStack {
            if let route = viewModel.routeResult {
                RouteSummaryHeaderView(route: route)
                RouteInputCardView(
                    route: route,
                    wayPoints: route.wayPoints.map { $0.name }
                )
                .padding(.bottom, 12)
            }
            
            ScrollView {
                if let route = viewModel.routeResult {
                    RouteTimelineView(route: route)
                } else if case .error(let message) = viewModel.state {
                    VStack(spacing: 12) {
                        Text("경로를 찾을 수 없습니다")
                            .font(.medium16)
                        
                        Text(message)
                            .font(.medium12)
                            .foregroundStyle(.gray2)
                    }
                } else
                {
                    ProgressView("경로 찾는 중...") }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Divider()
                    .padding(.bottom, 15)
                
                RouteBottomActionView { viewModel.state = .endingConfirm }
            }
            .background(Color.white)
        }
        // MARK: - 상태 연결
        .onChange(of: viewModel.state) { _, state in
            switch state {
            case .arrived:
                isArrivalAlertPresented = true
            case .endingConfirm:
                isEndConfirmPresented = true
            case .ended:
                NotificationCenter.default.post(name: .routeDidEnd, object: nil)
                dismiss()
            default:
                break
            }
        }

        // MARK: - 도착 Alert
        .alert("도착지 부근입니다", isPresented: $isArrivalAlertPresented) {
            Button("확인", role: .cancel) {
                detailViewModel.stopLiveRefresh()
                detailViewModel.homeViewModel.arrivedScheduleIds.insert(
                    detailViewModel.scheduleId
                )
                viewModel.endRouteManually()
            }
        } message: {
            Text("길안내를 종료합니다.")
        }

        // MARK: - 종료 Alert
        .alert("길찾기를 종료하시겠습니까?", isPresented: $isEndConfirmPresented) {
            Button("취소", role: .cancel) {
                viewModel.state = .navigating
            }
            Button("종료", role: .destructive) {
                handleManualEnd()
            }
        } message: {
            Text("종료 시 길찾기 재실행이 불가능합니다.")
        }

        .task {
            await viewModel.startRoute()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                Task { await viewModel.checkArrivalAfterBackground() }
            }
        }
        .padding(.bottom, 60)
    }

    private func handleManualEnd() {
        detailViewModel.stopLiveRefresh()
        detailViewModel.homeViewModel.arrivedScheduleIds.insert(
            detailViewModel.scheduleId
        )

        viewModel.endRouteManually()
        Task { await viewModel.endRoute() }
    }
}

extension Notification.Name {
    static let routeDidEnd = Notification.Name("routeDidEnd")
}
