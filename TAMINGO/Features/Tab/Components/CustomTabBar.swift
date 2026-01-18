//
//  CustomTabBar.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: MainTab

    var body: some View {
        VStack(spacing: 0) {

            Divider()

            HStack {
                ForEach(MainTab.allCases, id: \.self) { tab in
                    TabBarItem(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        selectedTab = tab
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 12)
            .background(Color.white)
        }
    }
}

