import Foundation

final class EmailVerificationRepositoryMock: EmailVerificationProtocol {

    // UI 확인을 위한 하드코딩 인증번호
    private let fixedCode: String = "123456"
    private var issuedCode: String = "123456"

    private let artificialDelayNs: UInt64
    private let forceSendErrorStatus: Int?
    private let forceVerifyErrorStatus: Int?

    init(
        artificialDelaySeconds: Double = 0.4,
        forceSendErrorStatus: Int? = nil,
        forceVerifyErrorStatus: Int? = nil
    ) {
        self.artificialDelayNs = UInt64(artificialDelaySeconds * 1_000_000_000)
        self.forceSendErrorStatus = forceSendErrorStatus
        self.forceVerifyErrorStatus = forceVerifyErrorStatus
    }

    func sendCode(email: String) async throws -> SendCodeResponseDTO {
        try await Task.sleep(nanoseconds: artificialDelayNs)

        if let status = forceSendErrorStatus {
            throw mockError(status: status)
        }

        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw APIError.server(status: 400, message: "이메일을 입력해주세요.")
        }
        if !EmailValidator.isValid(email) {
            throw APIError.server(status: 400, message: "올바른 이메일 형식이 아닙니다.")
        }

        // 항상 같은 코드 발급
        issuedCode = fixedCode
        print("MOCK issued code:", issuedCode)

        return SendCodeResponseDTO(expiresInSec: 300) // 5분 타이머(명세서)
    }

    func verifyCode(code: String) async throws -> VerifyCodeResponseDTO {
        try await Task.sleep(nanoseconds: artificialDelayNs)

        if let status = forceVerifyErrorStatus {
            throw mockError(status: status)
        }

        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            throw APIError.server(status: 400, message: "인증번호를 입력해주세요.")
        }
        if trimmed.count != 6 || trimmed.range(of: #"^\d{6}$"#, options: .regularExpression) == nil {
            throw APIError.server(status: 400, message: "인증번호 형식이 올바르지 않습니다.")
        }

        guard trimmed == issuedCode else {
            throw APIError.server(status: 401, message: "인증번호가 일치하지 않습니다.")
        }

        return VerifyCodeResponseDTO(
            verificationToken: UUID().uuidString,
            tokenExpiresInSec: 300
        )
    }

    private func mockError(status: Int) -> APIError {
        switch status {
        case 404: return .server(status: 404, message: "존재하지 않는 회원가입 세션입니다.")
        case 410: return .server(status: 410, message: "인증번호가 만료되었습니다.")
        case 500: return .server(status: 500, message: "인증번호 발송 중 오류가 발생했습니다.")
        default:  return .server(status: status, message: "오류가 발생했습니다.")
        }
    }
}
