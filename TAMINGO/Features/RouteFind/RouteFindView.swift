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
                RouteTimelineView(route: route)
            } else {
                ProgressView("경로 찾는 중...")
            }
        }
        .task {
            await viewModel.startRoute()
        }
    }
}

#Preview {
    RouteFindView(scheduleId: 818)
}
