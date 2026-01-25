import Foundation

@Observable
final class IdCreateViewModel {

    var email: String

    // 입력 데이터
    var nickname: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    init(email: String) {
        self.email = email
    }

    var nicknameDone: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var passwordDone: Bool {
        !password.isEmpty
    }

    var confirmDone: Bool {
        !confirmPassword.isEmpty
    }

    var isMatch: Bool {
        confirmDone && (password == confirmPassword)
    }

    // 상위 항목 입력 전에는 아래 입력 비활성
    var canEditPassword: Bool { nicknameDone }
    var canEditConfirm: Bool { passwordDone }

    var canNext: Bool { nicknameDone && passwordDone && isMatch }

    func primaryAction(onNext: (String, String) -> Void) {
        guard canNext else { return }
        onNext(nickname, password)
    }
}
