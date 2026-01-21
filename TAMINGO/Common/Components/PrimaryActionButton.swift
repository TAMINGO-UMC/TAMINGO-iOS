import SwiftUI

struct PrimaryActionButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.semiBold14)
                .foregroundStyle(isEnabled ? Color(.white) : Color("Gray2"))
                .frame(width: 332, height: 47)
                .background(isEnabled ? Color("MainMint") : Color("Gray1"))
                .cornerRadius(5)
        }
        .disabled(!isEnabled)
    }
}
