import Foundation

struct APIErrorResponseDTO: Decodable {
    let status: Int
    let message: String
}

enum APIError: Error, LocalizedError {
    case server(status: Int, message: String)
    case transport(String)

    var errorDescription: String? {
        switch self {
        case .server(_, let message): return message
        case .transport(let msg): return msg
        }
    }

    var statusCode: Int? {
        if case .server(let status, _) = self { return status }
        return nil
    }
}
