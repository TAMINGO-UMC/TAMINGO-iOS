import Foundation

struct SendCodeRequestDTO: Codable {
    let email: String
}

struct SendCodeResponseDTO: Codable {
    let expiresInSec: Int
}
