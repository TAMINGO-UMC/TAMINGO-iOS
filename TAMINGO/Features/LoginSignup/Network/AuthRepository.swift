//
//  AuthRepository.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import Foundation
import Moya

protocol AuthRepositoryProtocol {
    func getTerms() async throws -> [TermDTO]
    func createSession(terms: CreateSessionRequestDTO) async throws -> CreateSessionResponseDTO
    func sendCode(sessionId: String, email: String) async throws -> SendCodeResponseDTO
    func verifyCode(sessionId: String, email: String, code: String) async throws -> VerifyCodeResponseDTO
    func signup(sessionId: String, nickname: String, password: String) async throws -> SignupResponseDTO
    func login(email: String, password: String) async throws -> LoginResponseDTO
    func kakaoLogin(kakaoToken: String) async throws -> LoginResponseDTO
    func refreshToken(refreshToken: String) async throws -> RefreshTokenResponseDTO
}

final class AuthRepository: AuthRepositoryProtocol, Sendable{
    
    private let provider: MoyaProvider<AuthTarget>
    private let decoder = JSONDecoder()
    
    init(provider: MoyaProvider<AuthTarget>? = nil) {
        if let provider = provider {
            self.provider = provider
        } else {
            let logger = NetworkLoggerPlugin(configuration: .init(logOptions: [.verbose]))
            self.provider = MoyaProvider<AuthTarget>(plugins: [logger])
        }
    }
    
    // MARK: - 1. 약관 목록 조회
    func getTerms() async throws -> [TermDTO] {
        let response = try await provider.requestAsync(.getTerms)
        let decoded = try decodeOrThrow(response, as: [TermDTO].self)
        return decoded
    }
    
    // MARK: - 2. 회원가입 세션 생성
    func createSession(terms: CreateSessionRequestDTO) async throws -> CreateSessionResponseDTO {
        let response = try await provider.requestAsync(.createSession(body: terms))
        return try decodeOrThrow(response, as: CreateSessionResponseDTO.self)
    }
    
    // MARK: - 3. 이메일 인증번호 발송
    func sendCode(sessionId: String, email: String) async throws -> SendCodeResponseDTO {
        let body = SendCodeRequestDTO(email: email)
        let response = try await provider.requestAsync(.sendCode(sessionId: sessionId, body: body))
        return try decodeOrThrow(response, as: SendCodeResponseDTO.self)
    }
    
    // MARK: - 4. 이메일 인증번호 확인
    func verifyCode(sessionId: String, email: String, code: String) async throws -> VerifyCodeResponseDTO {
        let body = VerifyCodeRequestDTO(email: email, code: code)
        let response = try await provider.requestAsync(.verifyCode(sessionId: sessionId, body: body))
        return try decodeOrThrow(response, as: VerifyCodeResponseDTO.self)
    }
    
    // MARK: - 5. 아이디 생성 (회원가입 완료)
    func signup(sessionId: String, nickname: String, password: String) async throws -> SignupResponseDTO {
        let body = SignupRequestDTO(nickname: nickname, password: password)
        let response = try await provider.requestAsync(.signup(sessionId: sessionId, body: body))
        return try decodeOrThrow(response, as: SignupResponseDTO.self)
    }
    
    // MARK: - 6. 로그인
    func login(email: String, password: String) async throws -> LoginResponseDTO {
        let body = LoginRequestDTO(email: email, password: password)
        let response = try await provider.requestAsync(.login(body: body))
        return try decodeOrThrow(response, as: LoginResponseDTO.self)
    }
    
    // MARK: - 7. 카카오 로그인
    func kakaoLogin(kakaoToken: String) async throws -> LoginResponseDTO {
        let body = KakaoLoginRequestDTO(kakaoAccessToken: kakaoToken)
        let response = try await provider.requestAsync(.kakaoLogin(body: body))
        return try decodeOrThrow(response, as: LoginResponseDTO.self)
    }
    
    // MARK: - 8. 토큰 재발급 (TokenManager에서 자동으로 처리됨)
    func refreshToken(refreshToken: String) async throws -> RefreshTokenResponseDTO {
        let response = try await provider.requestAsync(.refreshToken(refreshToken: refreshToken))
        return try decodeOrThrow(response, as: RefreshTokenResponseDTO.self)
    }

    // MARK: - Decode Helper
    private func decodeOrThrow<T: Decodable>(_ response: Response, as type: T.Type) throws -> T {
        if (200..<300).contains(response.statusCode) {
            do {
                let baseResponse = try decoder.decode(BaseResponse<T>.self, from: response.data)
                guard let result = baseResponse.result else {
                    throw APIError.server(status: response.statusCode, message: "서버 응답 결과(result)가 비어있습니다.")
                }
                return result
            } catch {
                if let apiError = error as? APIError { throw apiError }
                throw APIError.transport("디코딩 실패: \(error.localizedDescription)")
            }
        } else {
            // [수정됨] 에러 발생 시 서버 응답 바디를 문자열로 변환하여 로깅
            let errorBody = String(data: response.data, encoding: .utf8) ?? "알 수 없는 데이터"
            print("[AuthRepository] 서버 에러 응답 Body: \(errorBody)")
            
            // 1. 정해진 에러 포맷(APIErrorResponseDTO)으로 디코딩 시도
            if let errorResponse = try? decoder.decode(APIErrorResponseDTO.self, from: response.data) {
                throw APIError.server(status: errorResponse.status, message: errorResponse.message)
            } else {
                // 2. 포맷이 맞지 않으면 Raw Body 자체를 에러 메시지로 사용
                throw APIError.server(status: response.statusCode, message: "서버 오류: \(errorBody)")
            }
        }
    }
}
