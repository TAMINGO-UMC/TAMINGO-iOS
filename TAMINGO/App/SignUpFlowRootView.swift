import SwiftUI
import Foundation

struct SignupFlowRootView: View {
    @State private var emailVM = EmailSignupViewModel(mode: .mock)
    @State private var progressStore = SignupProgressStore()

    @State private var step: SignupStep = .email
    @State private var goToIdCreate = false
    @State private var goToComplete = false   

    @State private var email: String = ""
    @State private var token: String = ""

    @State private var nickname: String = "" // 완료 화면에 표시용
    @State private var password: String = "" // (필요하면 이후 API 요청용)

    var body: some View {
        NavigationStack {
            EmailInputView(
                vm: emailVM,
                onBack: { },
                onNext: { email, token in
                    self.email = email
                    self.token = token

                    step = .idCreate
                    Task { @MainActor in progressStore.set(step.progress, animated: true) }

                    goToIdCreate = true
                }
            )
            .navigationDestination(isPresented: $goToIdCreate) {
                IdCreateView(
                    vm: IdCreateViewModel(email: email),
                    onNext: { nickname, password in
                        self.nickname = nickname
                        self.password = password

                        // 완료 화면 progress 1.0
                        step = .done
                        Task { @MainActor in progressStore.set(step.progress, animated: true) }

                        goToComplete = true
                    },
                    onBack: {
                        step = .email
                        Task { @MainActor in progressStore.set(step.progress, animated: true) }
                        goToIdCreate = false
                    }
                )
            }
            .navigationDestination(isPresented: $goToComplete) {
                SignupCompleteView(nickname: nickname) {
                    // 추후에 로그인 화면으로 이동하는 로직 추가
                    print("로그인 버튼 탭")
                }
            }
            .onAppear {
                Task { @MainActor in progressStore.set(SignupStep.email.progress, animated: false) }
            }
        }
        .environment(progressStore)
    }
}
