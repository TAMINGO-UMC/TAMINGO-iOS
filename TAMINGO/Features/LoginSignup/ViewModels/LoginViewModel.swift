//
//  LoginViewModel.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

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
        // 카카오 SDK로 로그인 시도
        Task {
            await performKakaoLogin()
        }
    }
    
    // MARK: - 카카오 로그인 실행
    @MainActor
    private func performKakaoLogin() async {
        #if DEBUG
        print("🟡 카카오 로그인 시작")
        #endif
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // 1. 카카오 SDK로 액세스 토큰 획득
            let kakaoAccessToken = try await getKakaoAccessToken()
            
            #if DEBUG
            print("✅ 카카오 액세스 토큰 획득 성공")
            #endif
            
            // 2. 서버에 카카오 토큰 전달하여 로그인
            let response = try await repo.kakaoLogin(kakaoToken: kakaoAccessToken)
            
            // 3. 토큰 저장
            TokenManager.shared.saveAccessToken(response.accessToken)
            TokenManager.shared.saveRefreshToken(response.refreshToken)
            TokenManager.shared.saveUserId(response.userId)
            
            #if DEBUG
            print("✅ 카카오 로그인 성공: userId = \(response.userId)")
            #endif
            
            isLoginFailed = false
            actionSubject.send(.loginSuccess(
                userId: response.userId,
                onboardingCompleted: response.onboardingCompleted
            ))
            
        } catch {
            #if DEBUG
            print("❌ 카카오 로그인 실패: \(error.localizedDescription)")
            #endif
            isLoginFailed = true
            // 카카오 로그인 실패는 입력 필드를 초기화하지 않음
        }
    }
    
    // MARK: - 카카오 SDK 액세스 토큰 획득
    private func getKakaoAccessToken() async throws -> String {
        // 카카오 SDK import 필요
        // import KakaoSDKAuth
        // import KakaoSDKUser
        
        return try await withCheckedThrowingContinuation { continuation in
            // 카카오톡 앱이 설치되어 있는지 확인
            if UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡으로 로그인
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    if let token = oauthToken?.accessToken {
                        continuation.resume(returning: token)
                    } else {
                        continuation.resume(throwing: NSError(
                            domain: "KakaoLogin",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "카카오 액세스 토큰을 받지 못했습니다."]
                        ))
                    }
                }
            } else {
                // 카카오 계정으로 로그인 (웹 브라우저)
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    if let token = oauthToken?.accessToken {
                        continuation.resume(returning: token)
                    } else {
                        continuation.resume(throwing: NSError(
                            domain: "KakaoLogin",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "카카오 액세스 토큰을 받지 못했습니다."]
                        ))
                    }
                }
            }
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
