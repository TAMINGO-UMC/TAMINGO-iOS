import SwiftUI
struct SignupTopBar: View {
    let progress: CGFloat
    let title: String
    var onBack: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {

            
            StepProgressBar(progress: progress)
                .frame(height: 8)
                .padding(.horizontal, 20)
                .padding(.top, 10)

            
            HStack(spacing: 10) {
                BackChevronButton { onBack?() }

                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)

                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.top, 6)
        }
    }
}

