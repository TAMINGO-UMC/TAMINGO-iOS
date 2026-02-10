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
    
    // MARK: - 카카오 로그인
    func kakaoLoginTapped() {
        Task {
            await handleKakaoLogin()
        }
    }
    
    @MainActor
    private func handleKakaoLogin() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            print("🚀 카카오 로그인 시작")
            
            // 1. 카카오 SDK로 로그인 (카카오 액세스 토큰 획득)
            let kakaoAccessToken = try await KakaoAuthManager.shared.login()
            print("✅ 카카오 액세스 토큰 획득 성공")
            
            // 2. 백엔드에 카카오 토큰 전송 (우리 서비스 토큰 발급)
            print("📤 백엔드에 카카오 토큰 전송 중...")
            let response = try await repo.kakaoLogin(kakaoToken: kakaoAccessToken)
            print("✅ 백엔드 로그인 성공")
            
            // 3. 토큰 저장
            TokenManager.shared.saveAccessToken(response.accessToken)
            TokenManager.shared.saveRefreshToken(response.refreshToken)
            TokenManager.shared.saveUserId(response.userId)
            print("✅ 토큰 저장 완료")
            
            print("👤 userId: \(response.userId)")
            print("🎯 onboardingCompleted: \(response.onboardingCompleted)")
            
            // 4. 로그인 성공 알림
            NotificationCenter.default.post(name: .userDidLogin, object: nil)
            
            // 5. 화면 전환
            isLoginFailed = false
            actionSubject.send(.loginSuccess(
                userId: response.userId,
                onboardingCompleted: response.onboardingCompleted
            ))
            
        } catch let apiError as APIError {
            print("❌ API 에러 발생: \(apiError)")
            handleAPIError(apiError)
        } catch {
            print("❌ 카카오 로그인 실패: \(error)")
            isLoginFailed = true
        }
    }
    
    // MARK: - API 에러 처리
    private func handleAPIError(_ error: APIError) {
        switch error {
        case .server(let status, let message):
            print("🔴 서버 에러 - Status: \(status), Message: \(message)")
            // 카카오 로그인은 일반 로그인과 다른 에러 처리
            isLoginFailed = true
            
        case .transport(let message):
            print("🔴 네트워크 에러: \(message)")
            isLoginFailed = true
        }
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
            
            // 로그인 성공 알림
            NotificationCenter.default.post(name: .userDidLogin, object: nil)
            
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
