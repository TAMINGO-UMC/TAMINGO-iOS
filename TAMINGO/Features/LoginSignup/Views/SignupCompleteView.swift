import SwiftUI

struct SignupCompleteView: View {
    @Environment(SignupProgressStore.self) private var progressStore
    @Environment(SignupSessionStore.self) private var sessionStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {

            StepProgressBar(progress: progressStore.progress)
                .frame(height: 8)
                .padding(.horizontal, 20)
                .padding(.top, 10)

            Spacer().frame(height: 90)

            Image("Sign")
                .resizable()
                .scaledToFit()
                .frame(width: 315, height: 283)
                .padding(.bottom, 26)
            VStack(spacing: 2) {
                HStack(spacing: 0) {
                    Text(sessionStore.nickname)
                        .font(.bold24)
                        .foregroundStyle(Color("MainMint"))

                    Text("님의")
                        .font(.bold24)
                        .foregroundStyle(Color("Gray2"))
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Text("회원가입이 완료되었습니다.")
                    .font(.bold24)
                    .foregroundStyle(Color("Gray2"))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .multilineTextAlignment(.center)

            Spacer()

            PrimaryActionButton(title: "로그인", isEnabled: true) {
                sessionStore.didFinishSignup = true
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task { @MainActor in
                progressStore.set(1.0, animated: true)
            }
        }
    }
}
