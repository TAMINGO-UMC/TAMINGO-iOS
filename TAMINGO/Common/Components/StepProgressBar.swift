import SwiftUI

struct StepProgressBar: View {
    let progress: CGFloat

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.06))

                Capsule()
                    .fill(Color("MainMint"))
                    .frame(width: geo.size.width * progress)
            }
        }
        .frame(height: 8)
    }
}
