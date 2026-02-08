import Foundation
import Moya

extension MoyaProvider {
    func requestAsync(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func request<T: Decodable>(_ target: Target) async throws -> T {
            // 1. 위의 requestAsync를 호출해서 데이터를 받음
            let response = try await requestAsync(target)
            
            // 2. JSON 디코딩 수행
            let decodedData = try JSONDecoder().decode(T.self, from: response.data)
            return decodedData
        }
}
