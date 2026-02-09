//
//  LoginViewModel.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import Foundation
import Combine

enum LoginAction {
    case goSignup
    case loginSuccess(userId: Int, onboardingCompleted: Bool)
    case kakaoLogin
}

final class LoginViewModel: ObservableObject {
    
    private let repo: AuthRepositoryProtocol
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isLoginFailed: Bool = false
    @Published var isLoading: Bool = false
    
    private var suppressClearCount: Int = 0
    
    private let actionSubject = PassthroughSubject<LoginAction, Never>()
    var actionPublisher: AnyPublisher<LoginAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    init(repo: AuthRepositoryProtocol = AuthRepository()) {
        self.repo = repo
    }
    
    var canLogin: Bool {
        !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !isLoading
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
        // TODO: 카카오 SDK 연동
    }
    
    // MARK: - API: 로그인
    @MainActor
    func loginTapped() async {
        let trimmedId = id.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedId.isEmpty, !trimmedPassword.isEmpty else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await repo.login(email: trimmedId, password: trimmedPassword)
            
            // 토큰 저장 (TokenManager 사용)
            TokenManager.shared.saveAccessToken(response.accessToken)
            TokenManager.shared.saveRefreshToken(response.refreshToken)
            TokenManager.shared.saveUserId(response.userId)
            
            isLoginFailed = false
            actionSubject.send(.loginSuccess(
                userId: response.userId,
                onboardingCompleted: response.onboardingCompleted
            ))
        } catch {
            isLoginFailed = true
            resetInputsForRetry()
        }
    }
}
