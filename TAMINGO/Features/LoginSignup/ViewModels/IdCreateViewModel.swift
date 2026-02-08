//
//  IdCreateViewModel.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import Foundation
import Observation

@Observable
final class IdCreateViewModel {
    
    private let repo: AuthRepositoryProtocol
    var email: String
    
    var nickname: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    init(email: String, repo: AuthRepositoryProtocol = AuthRepository()) {
        self.email = email
        self.repo = repo
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
    
    var canNext: Bool { nicknameDone && isPasswordValid && isMatch && !isLoading }
    
    // MARK: - API: 회원가입 완료
    @MainActor
    func signup(sessionId: String, onSuccess: @escaping (SignupResponseDTO) -> Void) async {
        guard canNext else { return }
        
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await repo.signup(
                sessionId: sessionId,
                nickname: nickname,
                password: password
            )
            
            // 토큰 저장 (TokenManager 사용)
            TokenManager.shared.saveAccessToken(response.accessToken)
            TokenManager.shared.saveRefreshToken(response.refreshToken)
            TokenManager.shared.saveUserId(response.userId)
            
            onSuccess(response)
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "회원가입에 실패했습니다."
        }
    }
}
