import SwiftUI

struct LoginRootView: View {
    @StateObject private var vm = LoginViewModel()
    @State private var goSignup = false
    
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
                .onReceive(vm.actionPublisher) { action in
                    if case .goSignup = action { goSignup = true }
                }
            //회원가입 완료 신호 감지
                .onChange(of: signupSessionStore.didFinishSignup) { _, finished in
                    guard finished else { return }
                    
                    //회원가입 플로우 종료
                    goSignup = false
                    signupSessionStore.didFinishSignup = false
                }
        }
    }
}

