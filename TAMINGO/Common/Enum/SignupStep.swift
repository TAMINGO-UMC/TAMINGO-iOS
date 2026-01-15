import Foundation
enum SignupStep {
    case email
    case idCreate
    case done

    var progress: CGFloat {
        switch self {
        case .email:    return 1.0 / 3.0
        case .idCreate: return 2.0 / 3.0
        case .done:     return 1.0
        }
    }
}
