import SwiftUI

struct SignupCompleteView: View {
    @Environment(SignupProgressStore.self) private var progressStore

    let nickname: String
    var onLogin: (() -> Void)? = nil

    private var completeTitle: AttributedString {
        var all = AttributedString("\(nickname)님의\n회원가입이 완료되었습니다.")

        all.font = .system(size: 24, weight: .bold)
        all.kern = 0.5
        all.foregroundColor = Color("Gray2")

        if let range = all.range(of: nickname) {
            all[range].foregroundColor = Color("MainMint")
        }
        return all
    }

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
                .frame(width: 140, height: 140)
                .padding(.bottom, 26)

            Text(completeTitle)
                .multilineTextAlignment(.center)
                .lineSpacing(0)

            Spacer()

            // 공용 버튼
            PrimaryActionButton(title: "로그인", isEnabled: true) {
                onLogin?()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            Task { @MainActor in
                progressStore.set(1.0, animated: true)
            }
        }
    }
}


