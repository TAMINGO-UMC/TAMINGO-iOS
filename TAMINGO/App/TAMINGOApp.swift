//
//  TAMINGOApp.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import SwiftUI
import KakaoSDKCommon

@main
struct TAMINGOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var signupProgressStore = SignupProgressStore()
    @State private var signupSessionStore = SignupSessionStore()

    @State private var isLoggedIn = false
    @State private var isLoading = true

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
                    // [수정] 중괄호 {} 안에 isLoggedIn = true 로직 추가
                    LoginRootView {
                        print("로그인 성공 콜백 감지: 메인 화면으로 전환")
                        isLoggedIn = true
                    }
                    .environment(signupProgressStore)
                    .environment(signupSessionStore)
                }
            }
            .task {
                await checkLoginStatus()
            }
            // 로그인 성공 이벤트 수신 (NotificationCenter 방식도 유지)
            .onReceive(NotificationCenter.default.publisher(for: .userDidLogin)) { _ in
                print("로그인 알림 감지: 메인 화면으로 전환")
                isLoggedIn = true
            }
            // 로그아웃 이벤트 수신
            .onReceive(NotificationCenter.default.publisher(for: .userDidLogout)) { _ in
                print("로그아웃 알림 감지: 로그인 화면으로 전환")
                isLoggedIn = false
            }
        }
    }

    private func checkLoginStatus() async {
        guard TokenManager.shared.getAccessToken() != nil,
              TokenManager.shared.getRefreshToken() != nil else {
            isLoggedIn = false
            isLoading = false
            print("저장된 토큰 없음 → 로그인 화면")
            return
        }
        
        print("자동 로그인: 저장된 토큰 발견")
        TokenManager.shared.printTokenStatus()
        
        isLoggedIn = true
        isLoading = false
        
        print("메인 화면으로 진입 (만료 시 첫 API 요청에서 자동 갱신)")
    }
}
