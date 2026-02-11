//
//  AuthTarget.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import Foundation
import Moya
import Alamofire

enum AuthTarget {
    // 1. 약관 목록 조회
    case getTerms
    
    // 2. 회원가입 세션 생성
    case createSession(body: CreateSessionRequestDTO)
    
    // 3. 이메일 인증번호 발송
    case sendCode(sessionId: String, body: SendCodeRequestDTO)
    
    // 4. 이메일 인증번호 확인
    case verifyCode(sessionId: String, body: VerifyCodeRequestDTO)
    
    // 5. 아이디 생성 (회원가입 완료)
    case signup(sessionId: String, body: SignupRequestDTO)
    
    // 6. 로그인
    case login(body: LoginRequestDTO)
    
    // 7. 카카오 로그인
    case kakaoLogin(body: KakaoLoginRequestDTO)
    
    // 8. 토큰 재발급
    case refreshToken(refreshToken: String)
}

// MARK: - APITargetType 구현
extension AuthTarget: APITargetType {
    
    nonisolated var path: String {
        switch self {
        case .getTerms:
            return "/api/terms"
        case .createSession:
            return "/api/auth/signup/sessions"
        case .sendCode:
            return "/api/auth/signup/email/code"
        case .verifyCode:
            return "/api/auth/signup/email/verify"
        case .signup:
            return "/api/auth/signup/complete"
        case .login:
            return "/api/auth/login"
        case .kakaoLogin:
            return "/api/auth/login/kakao"
        case .refreshToken:
            return "/api/auth/token/refresh"
        }
    }
    
    nonisolated var method: Moya.Method {
        switch self {
        case .getTerms:
            return .get
        case .createSession, .sendCode, .verifyCode, .signup, .login, .kakaoLogin, .refreshToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getTerms:
            return .requestPlain
            
        case .createSession(let body):
            return .requestJSONEncodable(body)
            
        case .sendCode(_, let body):
            return .requestJSONEncodable(body)
            
        case .verifyCode(_, let body):
            return .requestJSONEncodable(body)
            
        case .signup(_, let body):
            return .requestJSONEncodable(body)
            
        case .login(let body):
            return .requestJSONEncodable(body)
            
        case .kakaoLogin(let body):
            return .requestJSONEncodable(body)
            
        case .refreshToken:
            return .requestPlain
        }
    }
    
    nonisolated var headers: [String: String]? {
        var baseHeaders = [
            "Content-Type": "application/json"
        ]
        
        // Authorization은 기본 헤더에서 제공되므로 특별한 경우만 추가
        switch self {
        case .sendCode(let sessionId, _),
             .verifyCode(let sessionId, _),
             .signup(let sessionId, _):
            baseHeaders["X-Signup-Session-Id"] = sessionId
            
        case .refreshToken(let refreshToken):
            baseHeaders["X-Refresh-Token"] = refreshToken
            
        default:
            break
        }
        
        return baseHeaders
    }
    
    nonisolated var sampleData: Data {
        switch self {
        case .getTerms:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": [
                {
                  "code": "SERVICE",
                  "title": "이용약관 동의",
                  "isRequired": true
                },
                {
                  "code": "PRIVACY",
                  "title": "개인정보 수집 및 이용 동의",
                  "isRequired": true
                },
                {
                  "code": "AI_SERVICE",
                  "title": "AI 기반 서비스 이용약관 동의",
                  "isRequired": true
                },
                {
                  "code": "LOCATION",
                  "title": "위치기반 서비스 이용약관 동의",
                  "isRequired": true
                },
                {
                  "code": "MARKETING",
                  "title": "마케팅 알림 수신 동의",
                  "isRequired": false
                }
              ]
            }
            """.data(using: .utf8)!
            
        case .createSession:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "signupSessionId": "b3a6f8c2-1234-5678-90ab-cdef12345678",
                "expiresInSec": 900
              }
            }
            """.data(using: .utf8)!
            
        case .sendCode:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "expiresInSec": 300
              }
            }
            """.data(using: .utf8)!
            
        case .verifyCode:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "verified": true
              }
            }
            """.data(using: .utf8)!
            
        case .signup:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-201",
              "message": "리소스가 생성되었습니다.",
              "result": {
                "userId": 1,
                "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
                "refreshToken": "eyJhbGciOiJIUzI1NiJ9..."
              }
            }
            """.data(using: .utf8)!
            
        case .login, .kakaoLogin:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청이 성공했습니다.",
              "result": {
                "userId": 1,
                "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
                "refreshToken": "eyJhbGciOiJIUzI1NiJ9...",
                "onboardingCompleted": false
              }
            }
            """.data(using: .utf8)!
            
        case .refreshToken:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "accessToken": "eyJhbGciOiJIUzI1NiJ9..."
              }
            }
            """.data(using: .utf8)!
        }
    }
}
