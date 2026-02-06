import SwiftUI

struct SignupTopBar: View {
    let progress: CGFloat
    let title: String
    var showsProgress: Bool = true
    var onBack: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: showsProgress ? 5 : 0) {

            if showsProgress {
                StepProgressBar(progress: progress)
                    .frame(height: 8)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }

            HStack(spacing: 10) {
                Button {
                    onBack?()
                } label: {
                    Image("Previous_Chevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 9.05, height: 15.35) // 필요하면 사이즈만 조절
                        .contentShape(Rectangle())    // 터치 영역 안정화
                }
                .buttonStyle(.plain)

                Text(title)
                    .font(.medium24)
                    .foregroundStyle(.black)

                Spacer()
            }
            .padding(.leading, 20)   // ✅ 값 키울수록 더 오른쪽
            .padding(.trailing, 20)
            .padding(.top, 20)
        }
    }
}
