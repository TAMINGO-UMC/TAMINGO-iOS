//
//  NotificationView.swift
//  TAMINGO
//
//  Created by 김도연 on 2/9/26.
//

import SwiftUI

struct NotificationView: View {
    @State private var viewModel = NotificationSettingViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            MyPageHeader(title: "알림 설정")
            
            startAlert
            
            todoToggleBox
            
            locationToggleBox
            
            GuideBoxView(
                title: "알림 안내",
                description: "• 알림은 활동 시간 내에만 발송됩니다\n• 중요 알림(지각 위험)은 항상 발송됩니다\n• 시스템 설정에서 알림 권한을 허용해주세요")
            
            Spacer()
        }
        .padding()
        .task {
            viewModel.fetchSettings()
        }
        .onChange(of: viewModel.currentSettings) {
            viewModel.dispatchUpdate()
        }
    }
    
    var startAlert: some View {
        VStack(spacing: 0) {
            ToggleBox(
                // 옵셔널 해제 및 rawValue 사용 수정
                title: "출발 알림 (T-\(viewModel.departureAlertMinutes.rawValue)분)",
                sub: "일정 시작 시간 \(viewModel.departureAlertMinutes.rawValue)분 전 도착을 목표로 출발 알림",
                isOn: $viewModel.departureAlertEnabled
            )
            HStack {
                Text("도착 시간 조정")
                    .font(.regular12)
                    .foregroundStyle(.gray2)
                
                Spacer()
                
                Menu {
                    // Selection 타입을 ViewModel의 타입과 일치시킴
                    Picker("알림 시간 설정", selection: $viewModel.departureAlertMinutes) {
                        ForEach(ArrivalBufferType.allCases) { type in
                            Text("\(type.rawValue)분 전")
                                .tag(type) // as ArrivalBufferType? 제거
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("\(viewModel.departureAlertMinutes.rawValue)분 전")
                            .font(.medium14)
                            .foregroundStyle(.mainPink)
                        
                        Image("icon_pinkChevron")
                    }
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
        .cardStyle()
        .animation(.default, value: viewModel.departureAlertEnabled)
    }
    
    var todoToggleBox: some View {
        ToggleBox(
            title: "To-do 제안 알림",
            sub: "틈새 시간 및 경로 연계 할일 제안",
            isOn: $viewModel.todoRecommendEnabled
        )
        .padding(.horizontal)
        .cardStyle()
    }
    
    var locationToggleBox: some View {
        ToggleBox(
            title: "장소 이동 확인",
            sub: "현재 위치 기반 이동 여부 확인",
            isOn: $viewModel.locationMoveCheckEnabled
        )
        .padding(.horizontal)
        .cardStyle()
    }
}

#Preview {
    NotificationView()
}
