//
//  MainView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct MainView: View {
    @Bindable var homeViewModel: HomeScheduleViewModel
    
    var body: some View {
            MainScheduleView()
    }
}
