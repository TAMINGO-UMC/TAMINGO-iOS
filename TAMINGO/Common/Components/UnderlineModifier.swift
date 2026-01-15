import SwiftUI

extension View {
    func underline(isFocused: Bool) -> some View {
        overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color("MainMint").opacity(isFocused ? 1.0 : 0.25))
                .frame(height: isFocused ? 2 : 1)
        }
    }
}
