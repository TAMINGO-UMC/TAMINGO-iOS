import Foundation
import Observation
import SwiftUI


@Observable
final class SignupProgressStore {
    var progress: CGFloat = 0.0

    @MainActor
    func set(_ value: CGFloat, animated: Bool = true) {
        let v = max(0, min(value, 1))
        if animated {
            withAnimation(.easeInOut(duration: 0.28)) {
                progress = v
            }
        } else {
            progress = v
        }
    }
}
