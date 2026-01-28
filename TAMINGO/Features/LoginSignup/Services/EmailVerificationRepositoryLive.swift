import Foundation
import Moya

final class EmailVerificationRepositoryLive: EmailVerificationProtocol {

    private let provider: MoyaProvider<EmailVerificationAPI>
    private let decoder = JSONDecoder()

    // 초기화시 BaseURL을 받을 필요 
    init(provider: MoyaProvider<EmailVerificationAPI>? = nil) {
        let logger = NetworkLoggerPlugin(configuration: .init(logOptions: [.verbose]))
        self.provider = MoyaProvider<EmailVerificationAPI>(plugins: [logger])
    }

    func sendCode(email: String) async throws -> SendCodeResponseDTO {
        let target = EmailVerificationAPI(endpoint: .sendCode(email: email))
        let response = try await provider.requestAsync(target) // MoyaProvider+Extension 사용
        return try decodeOrThrow(response, as: SendCodeResponseDTO.self)
    }

    func verifyCode(code: String) async throws -> VerifyCodeResponseDTO {
        let target = EmailVerificationAPI(endpoint: .verifyCode(code: code))
        let response = try await provider.requestAsync(target)
        return try decodeOrThrow(response, as: VerifyCodeResponseDTO.self)
    }

    // Decode / Error Handling (API명세서 {status, message} 반영)

    private func decodeOrThrow<T: Decodable>(_ response: Response, as: T.Type) throws -> T {
        if (200..<300).contains(response.statusCode) {
            do {
                return try decoder.decode(T.self, from: response.data)
            } catch {
                throw APIError.transport("디코딩 실패: \(error.localizedDescription)")
            }
        } else {
            // 명세 에러 바디: { status, message }
            if let err = try? decoder.decode(APIErrorResponseDTO.self, from: response.data) {
                throw APIError.server(status: err.status, message: err.message)
            } else {
                throw APIError.server(status: response.statusCode, message: "서버 오류가 발생했습니다.")
            }
        }
    }
}
