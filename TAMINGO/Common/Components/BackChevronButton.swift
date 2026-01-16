import SwiftUI

struct BackChevronButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black)
                .frame(width: 33, height: 33)
        }
        .contentShape(Rectangle()) 
    }
}

#Preview {
    BackChevronButton { print("back") }
}
