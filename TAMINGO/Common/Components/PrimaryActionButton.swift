import SwiftUI

struct PrimaryActionButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 332, height: 47)
                .background(isEnabled ? Color("MainMint") : Color("Gray1").opacity(0.25))
                .cornerRadius(8)
        }
        .disabled(!isEnabled)
    }
}
