import SwiftUI

@main
struct TAMINGOApp: App {
    @State private var signupProgressStore = SignupProgressStore()
    @State private var signupSessionStore = SignupSessionStore()
    @State private var isLoggedIn = false
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    // 로딩 화면
                    ProgressView()
                        .scaleEffect(1.5)
                } else if isLoggedIn {
                    // 로그인 상태 → MainTabContainerView
                    MainTabContainerView()
                } else {
                    // 비로그인 상태 → LoginRootView
                    LoginRootView()
                        .environment(signupProgressStore)
                        .environment(signupSessionStore)
                }
            }
            .task {
                await checkLoginStatus()
            }
        }
    }
    
    // MARK: - 자동 로그인 체크
    private func checkLoginStatus() async {
        // 저장된 토큰 확인
        if TokenManager.shared.getAccessToken() != nil,
           TokenManager.shared.getRefreshToken() != nil {
            isLoggedIn = true
            print("✅ 자동 로그인: 저장된 토큰 발견")
        } else {
            print("ℹ️ 저장된 토큰 없음 → 로그인 화면")
        }
        
        isLoading = false
    }
}
