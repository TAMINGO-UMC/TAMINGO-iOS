//
//  AuthDTO.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import Foundation

// MARK: - 1. 약관 목록 조회
struct TermDTO: Codable, Sendable{
    let code: String
    let title: String
    let isRequired: Bool
}

// MARK: - 2. 회원가입 세션 생성 Request
struct CreateSessionRequestDTO: Codable, Sendable{
    let terms: [String: Bool]
}

// MARK: - 2. 회원가입 세션 생성 Response
struct CreateSessionResponseDTO: Codable, Sendable{
    let signupSessionId: String
    let expiresInSec: Int
}

// MARK: - 3. 이메일 인증번호 발송 Request
struct SendCodeRequestDTO: Codable, Sendable{
    let email: String
}

// MARK: - 3. 이메일 인증번호 발송 Response
struct SendCodeResponseDTO: Codable, Sendable{
    let expiresInSec: Int
}

// MARK: - 4. 이메일 인증번호 확인 Request
struct VerifyCodeRequestDTO: Codable, Sendable{
    let email: String
    let code: String
}

// MARK: - 4. 이메일 인증번호 확인 Response
struct VerifyCodeResponseDTO: Codable, Sendable{
    let verified: Bool
}

// MARK: - 5. 아이디 생성 (회원가입 완료) Request
struct SignupRequestDTO: Codable, Sendable{
    let nickname: String
    let password: String
}

// MARK: - 5. 아이디 생성 (회원가입 완료) Response
struct SignupResponseDTO: Codable, Sendable{
    let userId: Int
    let accessToken: String
    let refreshToken: String
}

// MARK: - 6. 로그인 Request
struct LoginRequestDTO: Codable, Sendable{
    let email: String
    let password: String
}

// MARK: - 6. 로그인 Response
struct LoginResponseDTO: Codable, Sendable{
    let userId: Int
    let accessToken: String
    let refreshToken: String
    let onboardingCompleted: Bool
}

// MARK: - 7. 카카오 로그인 Request
struct KakaoLoginRequestDTO: Codable, Sendable{
    let kakaoAccessToken: String
}

// MARK: - 8. 토큰 재발급 Response
struct RefreshTokenResponseDTO: Codable, Sendable{
    let accessToken: String
}
