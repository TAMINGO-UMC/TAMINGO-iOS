import SwiftUI

struct LoginRootView: View {
    @StateObject private var vm = LoginViewModel()
    @State private var goSignup = false
    @State private var goOnboarding = false
    @State private var goHome = false
    
    // App에서 이미 주입했으니 여기선 받기만
    @Environment(SignupProgressStore.self) private var signupProgressStore
    @Environment(SignupSessionStore.self)  private var signupSessionStore
    
    var body: some View {
        NavigationStack {
            LoginView(vm: vm)
                .navigationDestination(isPresented: $goSignup) {
                    SignupEntryView()
                        .navigationBarBackButtonHidden(true)
                }
                .navigationDestination(isPresented: $goOnboarding) {
                    OnBoardingContainerView()
                        .navigationBarBackButtonHidden(true)
                }
                .navigationDestination(isPresented: $goHome) {
                    MainTabContainerView()
                        .navigationBarBackButtonHidden(true)
                }
                .onReceive(vm.actionPublisher) { action in
                    switch action {
                    case .goSignup:
                        goSignup = true
                        
                    case .loginSuccess(let userId, let onboardingCompleted):
                        print("로그인 성공: \(userId)")
                        if onboardingCompleted {
                            goHome = true           // 기존 사용자 → HomeView
                        } else {
                            goOnboarding = true     // 신규 사용자 → OnboardingView
                        }
                        
                    case .kakaoLogin:
                        print("카카오 로그인 시작")
                    }
                }
                //회원가입 완료 신호 감지
                .onChange(of: signupSessionStore.didFinishSignup) { _, finished in
                    guard finished else { return }
                    
                    //회원가입 플로우 종료
                    goSignup = false
                    signupSessionStore.reset()
                    signupProgressStore.set(0, animated: false)
                    signupSessionStore.didFinishSignup = false
                }
        }
    }
}
