//
//  KakaoAuthManager.swift
//  TAMINGO
//
//  카카오 로그인 SDK 연동
//

import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class KakaoAuthManager {
    static let shared = KakaoAuthManager()
    private init() {}
    
    // MARK: - 카카오 SDK 초기화 (AppDelegate에서 호출)
    func initializeSDK() {
        KakaoSDK.initSDK(appKey: Config.kakaoLoginKey)
        print("✅ 카카오 SDK 초기화 완료")
    }
    
    // MARK: - 카카오 로그인
    func login() async throws -> String {
        // 1. 카카오톡 앱이 설치되어 있는지 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            print("📱 카카오톡 앱으로 로그인 시도")
            return try await loginWithKakaoTalk()
        } else {
            print("🌐 카카오 계정으로 로그인 시도 (웹)")
            return try await loginWithKakaoAccount()
        }
    }
    
    // MARK: - 카카오톡 앱으로 로그인
    private func loginWithKakaoTalk() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print("❌ 카카오톡 로그인 실패: \(error)")
                    continuation.resume(throwing: error)
                } else if let token = oauthToken?.accessToken {
                    print("✅ 카카오톡 로그인 성공")
                    print("📱 카카오 Access Token: \(token.prefix(20))...")
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "KakaoAuth",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "토큰을 받지 못했습니다."]
                    ))
                }
            }
        }
    }
    
    // MARK: - 카카오 계정으로 로그인 (웹)
    private func loginWithKakaoAccount() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print("❌ 카카오 계정 로그인 실패: \(error)")
                    continuation.resume(throwing: error)
                } else if let token = oauthToken?.accessToken {
                    print("✅ 카카오 계정 로그인 성공")
                    print("🌐 카카오 Access Token: \(token.prefix(20))...")
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "KakaoAuth",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "토큰을 받지 못했습니다."]
                    ))
                }
            }
        }
    }
    
    // MARK: - 카카오 로그아웃
    func logout() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    print("❌ 카카오 로그아웃 실패: \(error)")
                    continuation.resume(throwing: error)
                } else {
                    print("✅ 카카오 로그아웃 성공")
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - 카카오 연결 해제 (회원탈퇴)
    func unlink() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.unlink { error in
                if let error = error {
                    print("❌ 카카오 연결 해제 실패: \(error)")
                    continuation.resume(throwing: error)
                } else {
                    print("✅ 카카오 연결 해제 성공")
                    continuation.resume()
                }
            }
        }
    }
}
