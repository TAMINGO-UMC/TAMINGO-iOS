import Foundation

struct VerifyCodeRequestDTO: Codable {
    let code: String
}

struct VerifyCodeResponseDTO: Codable {
    let verificationToken: String
    let tokenExpiresInSec: Int
}
