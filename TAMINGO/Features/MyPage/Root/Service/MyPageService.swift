//
//  MyPageService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/10/26.
//
import Alamofire
import Foundation
import Moya

protocol MyPageServiceProtocol {
    func fetchSummary() async throws -> MyPage
}

final class MyPageService: MyPageServiceProtocol {

    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()
    // 2. Provider 선언
    private let provider: MoyaProvider<MyPageAPI>
    
    // 3. init에서 Session 주입
    init() {
        self.provider = MoyaProvider<MyPageAPI>(
            session: session, // ✨ 핵심: 여기에 Interceptor가 포함된 session을 꼭 넣어야 합니다.
            plugins: [
                NetworkLoggerPlugin(configuration: .init(
                    logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
                ))
            ]
        )
    }
    
    func fetchSummary() async throws -> MyPage {
        let response = try await request(.fetchSummary)

        let decoded = try JSONDecoder().decode(
            BaseResponse<MyPageResponseDTO>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            throw APIError.server(status: 500, message: "Empty response")
        }

        return result.toDomain()
    }
}

private extension MyPageService {

    private func request(_ target: MyPageAPI) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)

                case .failure(let error):
                    if let response = error.response,
                       let apiErrorDTO = try? JSONDecoder().decode(
                            APIErrorResponseDTO.self,
                            from: response.data
                       ) {
                        continuation.resume(
                            throwing: APIError.server(
                                status: apiErrorDTO.status,
                                message: apiErrorDTO.message
                            )
                        )
                    }
                    else {
                        continuation.resume(
                            throwing: APIError.transport(
                                error.localizedDescription
                            )
                        )
                    }
                }
            }
        }
    }

}
