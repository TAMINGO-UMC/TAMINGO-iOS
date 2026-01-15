import Foundation

protocol EmailVerificationProtocol {
    func sendCode(email: String) async throws -> SendCodeResponseDTO
    func verifyCode(code: String) async throws -> VerifyCodeResponseDTO
}
