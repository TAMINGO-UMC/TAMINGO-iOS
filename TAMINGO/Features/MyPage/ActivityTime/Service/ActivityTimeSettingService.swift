//
//  ActivityTimeSettingService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/9/26.
//

import Foundation
import Moya

protocol ActivityTimeServiceProtocol {
    func fetchActivityTime() async throws -> ActivityTime
    func saveActivityTime(_ dto: ActivityTimeRequestDTO) async throws -> ActivityTime
}

final class ActivityTimeSettingService: ActivityTimeServiceProtocol {

    private let provider = MoyaProvider<ActivityTimeSettingAPI>(
        plugins: [
            NetworkLoggerPlugin(configuration: .init(
                logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
            ))
        ]
    )

    // MARK: - 조회
    func fetchActivityTime() async throws -> ActivityTime {
        let response = try await request(.fetchActivityTime)

        print("🟢 [ActivityTime] raw response:", String(data: response.data, encoding: .utf8) ?? "nil")

        let dto = try JSONDecoder().decode(
            ActivityTimeResponseDTO.self,
            from: response.data
        )

        print("🟢 [ActivityTime] decoded DTO:", dto)

        let domain = dto.toDomain()
        print("🟢 [ActivityTime] domain after toDomain:", domain)

        return domain
    }



    // MARK: - 저장
    func saveActivityTime(_ dto: ActivityTimeRequestDTO) async throws -> ActivityTime {
        let response = try await request(.saveActivityTime(dto))

        let decoded = try JSONDecoder().decode(
            BaseResponse<ActivityTimeResponseDTO>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            throw APIError.server(
                status: 500,
                message: "저장 결과가 없습니다."
            )
        }

        return result.toDomain()
    }

}


private extension ActivityTimeSettingService {

    func request(_ target: ActivityTimeSettingAPI) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)

                case .failure(let error):
                    print("🔴 [API] request failed:", error)
                    if let response = error.response,
                       let apiErrorDTO = try? JSONDecoder().decode(
                            APIErrorResponseDTO.self,
                            from: response.data
                       ) {
                        print("🔴 [API] status code:", response.statusCode)
                        continuation.resume(
                            throwing: APIError.server(
                                status: apiErrorDTO.status,
                                message: apiErrorDTO.message
                            )
                        )
                    } else {
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
