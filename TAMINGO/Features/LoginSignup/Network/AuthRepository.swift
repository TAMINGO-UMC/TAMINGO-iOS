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

final class AuthRepository: AuthRepositoryProtocol {
    
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
    
    // MARK: - Decode Helper (기존 BaseResponse 구조 사용)
    private func decodeOrThrow<T: Decodable>(_ response: Response, as type: T.Type) throws -> T {
        if (200..<300).contains(response.statusCode) {
            do {
                // 기존 BaseResponse 사용
                let baseResponse = try decoder.decode(BaseResponse<T>.self, from: response.data)
                guard let result = baseResponse.result else {
                    throw APIError.server(status: response.statusCode, message: "결과가 없습니다.")
                }
                return result
            } catch {
                throw APIError.transport("디코딩 실패: \(error.localizedDescription)")
            }
        } else {
            // 기존 APIErrorResponseDTO 사용
            if let errorResponse = try? decoder.decode(APIErrorResponseDTO.self, from: response.data) {
                throw APIError.server(status: errorResponse.status, message: errorResponse.message)
            } else {
                throw APIError.server(status: response.statusCode, message: "서버 오류가 발생했습니다.")
            }
        }
    }
}
