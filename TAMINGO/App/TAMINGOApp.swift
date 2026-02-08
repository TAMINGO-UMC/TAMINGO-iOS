//
//  TAMINGOApp.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct TAMINGOApp: App {
    @State private var signupProgressStore = SignupProgressStore()
    @State private var signupSessionStore = SignupSessionStore()
    
    @State private var isLoggedIn = false
    @State private var isLoading = true
    
    init() {
        // 카카오 SDK 초기화
        KakaoSDK.initSDK(appKey: Config.kakaoLoginKey)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if isLoggedIn {
                    // 로그인 상태 → 메인 화면
                    MainTabContainerView()
                } else {
                    // 비로그인 상태 → 로그인 화면
                    LoginRootView()
                        .environment(signupProgressStore)
                        .environment(signupSessionStore)
                        .onOpenURL { url in
                            // 카카오 로그인 콜백 처리
                            if AuthApi.isKakaoTalkLoginUrl(url) {
                                _ = AuthController.handleOpenUrl(url: url)
                            }
                        }
                }
            }
            .task {
                await checkLoginStatus()
            }
            // 로그인 성공 이벤트 수신
            .onReceive(NotificationCenter.default.publisher(for: .userDidLogin)) { _ in
                print("로그인 감지: 메인 화면으로 전환")
                isLoggedIn = true
            }
            // 로그아웃 이벤트 수신
            .onReceive(NotificationCenter.default.publisher(for: .userDidLogout)) { _ in
                print("로그아웃 감지: 로그인 화면으로 전환")
                isLoggedIn = false
            }
        }
    }
    
    private func checkLoginStatus() async {
        // 저장된 토큰 확인
        if TokenManager.shared.getAccessToken() != nil,
           TokenManager.shared.getRefreshToken() != nil {
            isLoggedIn = true
            print("자동 로그인: 저장된 토큰 발견")
        } else {
            isLoggedIn = false
            print("저장된 토큰 없음 → 로그인 화면")
        }
        
        isLoading = false
    }
}
