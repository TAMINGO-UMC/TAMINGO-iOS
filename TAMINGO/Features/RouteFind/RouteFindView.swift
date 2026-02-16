//
//  RouteFindView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct RouteFindView: View {
    
    @State private var viewModel: RouteGuideViewModel
    
    init(scheduleId: Int) {
        _viewModel = State(initialValue: RouteGuideViewModel(scheduleId: scheduleId))
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
                } else {
                    ProgressView("경로 찾는 중...")
                }
                
                RouteBottomActionView()
            }
        }
        .task {
            await viewModel.startRoute()
        }
        .padding(.bottom, 60)
    }
}

#Preview {
    RouteFindView(scheduleId: 818)
}
