import Foundation
import Moya
import Alamofire

struct EmailVerificationAPI: TargetType {

    enum Endpoint {
        case sendCode(email: String)
        case verifyCode(code: String)
    }

    let baseURL: URL
    let endpoint: Endpoint

    var path: String {
        switch endpoint {
        case .sendCode:
            return "/auth/email/send"     // 추후에 실제 path에 맞게 수정
        case .verifyCode:
            return "/auth/email/verify"   // 추후에 실제 path에 맞게 수정
        }
    }

    var method: Moya.Method { .post }

    var task: Task {
        switch endpoint {
        case .sendCode(let email):
            return .requestJSONEncodable(SendCodeRequestDTO(email: email))
        case .verifyCode(let code):
            return .requestJSONEncodable(VerifyCodeRequestDTO(code: code))
        }
    }

    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }

    /// Mocking용 sampleData (Moya stubbing에 사용 가능)
    var sampleData: Data {
        switch endpoint {
        case .sendCode:
            return #"{"expiresInSec":300}"#.data(using: .utf8) ?? Data()
        case .verifyCode:
            return #"{"verificationToken":"mock-token","tokenExpiresInSec":300}"#.data(using: .utf8) ?? Data()
        }
    }
}

