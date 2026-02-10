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
                    ToDoView()
                case .my:
                    MyPageView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(
                selectedTab: $selectedTab
            )
            
            // 임시 로그아웃 버튼 (오른쪽 하단)
            // 다시 실행하면 토큰 초기화, 로그인 화면 부터 실행
            #if DEBUG
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        TokenManager.shared.clearAll()
                        print("⚠️ 토큰 삭제 완료 - 앱 재시작")
                        exit(0)  // 앱 종료 (재시작하면 로그인 화면)
                    }) {
                        Image(systemName: "arrow.right.square.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 100)  // 탭바 위에 표시
                }
            }
            #endif
        }
        .ignoresSafeArea(edges: .bottom)
    }
}


#Preview {
    MainTabContainerView()
}
