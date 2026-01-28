//
//  MainTabContainerView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct MainTabContainerView: View {
    @State private var selectedTab: MainTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {

            Group {
                switch selectedTab {
                case .home:
                    MainView()
                case .calendar:
                    ScheduleView()
                case .todo:
                    MainView()
                case .my:
                    MainView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(
                selectedTab: $selectedTab
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}


#Preview {
    MainTabContainerView()
}
