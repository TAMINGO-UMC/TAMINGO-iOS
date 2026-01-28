import Foundation

@Observable
final class IdCreateViewModel {

    var email: String

    var nickname: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    init(email: String) {
        self.email = email
    }

    var nicknameDone: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var passwordDone: Bool { !password.isEmpty }
    var confirmDone: Bool { !confirmPassword.isEmpty }

    // 8~16자 + (영문/숫자/특수문자만 허용)
    private var passwordAllowedOnly: Bool {
        let pw = password
        let allowedPattern = "^[A-Za-z0-9!@#$%^&*()_+=\\-\\[\\]{};:'\",.<>/?`~\\\\|]+$"
        return pw.range(of: allowedPattern, options: .regularExpression) != nil
    }

    var isPasswordValid: Bool {
        (8...16).contains(password.count) && passwordAllowedOnly
    }

    var isMatch: Bool {
        confirmDone && (password == confirmPassword)
    }

    var canEditPassword: Bool { nicknameDone }
    var canEditConfirm: Bool { isPasswordValid }

    var canNext: Bool { nicknameDone && isPasswordValid && isMatch }

    func primaryAction(onNext: (String, String) -> Void) {
        guard canNext else { return }
        onNext(nickname, password)
    }
}
