//
//  TAMINGOApp.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import SwiftUI
import KakaoSDKCommon  // ⭐️ 추가

@main
struct TAMINGOApp: App {
    // AppDelegate 연결
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var signupProgressStore = SignupProgressStore()
    @State private var signupSessionStore = SignupSessionStore()
    
    @State private var isLoggedIn = false
    @State private var isLoading = true
    
    // 카카오 SDK 초기화
    init() {
        let kakaoAppKey = Config.kakaoLoginKey
        print("[TAMINGOApp.init] 카카오 앱 키: \(kakaoAppKey)")
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        print("[TAMINGOApp.init] 카카오 SDK 초기화 완료")
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
                    LoginRootView(){}
                        .environment(signupProgressStore)
                        .environment(signupSessionStore)
                }
            }
            .task {
                await checkLoginStatus()
            }
            // [수정됨] 로그인 성공 이벤트 수신
            .onReceive(NotificationCenter.default.publisher(for: .userDidLogin)) { _ in
                print("로그인 감지: 메인 화면으로 전환")
                isLoggedIn = true
            }
            // [수정됨] 로그아웃 이벤트 수신
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
