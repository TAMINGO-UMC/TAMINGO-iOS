import Foundation
import Combine

final class LoginViewModel: ObservableObject {


    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false

 
    @Published var isLoginFailed: Bool = false

    // resetInputs로 인한 onChange에서 에러가 바로 지워지는거 방지
    private var suppressClearCount: Int = 0

    // MARK: - Output(Action)
    private let actionSubject = PassthroughSubject<LoginAction, Never>()
    var actionPublisher: AnyPublisher<LoginAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }

    //하드코딩
    private let allowed: [(String, String)] = [
        ("1234", "1234"),
        ("test", "test1234")
    ]

    var canLogin: Bool {
        !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var errorMessage: String? {
        isLoginFailed ? "아이디 혹은 비밀번호가 일치하지 않습니다." : nil
    }


    func clearErrorIfNeeded() {
        if suppressClearCount > 0 {
            suppressClearCount -= 1
            return
        }
        if isLoginFailed { isLoginFailed = false }
    }

  
    private func resetInputsForRetry() {
        suppressClearCount = 2
        id = ""
        password = ""
        isPasswordVisible = false
    }

    func signupTapped() {
        actionSubject.send(.goSignup)
    }

    func kakaoLoginTapped() {
        actionSubject.send(.kakaoLogin)
    }

    func loginTapped() {
        let trimmedId = id.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let ok = allowed.contains{ $0.0 == trimmedId && $0.1 == trimmedPassword }
        if ok{
            isLoginFailed = false
            actionSubject.send(.loginSuccess(id: trimmedId))
        }else{
            isLoginFailed = true
            resetInputsForRetry()
        }
    }
}
