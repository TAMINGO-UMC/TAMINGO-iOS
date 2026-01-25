import Foundation
import Observation

@Observable
final class SignupSessionStore {
    var email: String = ""
    var verificationToken: String = ""

    var nickname: String = ""
    var password: String = ""
    
    var didFinishSignup: Bool = false
    var popToLoginFromEmail: Bool = false
}
extension SignupSessionStore {
    func reset() {
        email = ""
        verificationToken = ""
        nickname = ""
        password = ""
    }
}

