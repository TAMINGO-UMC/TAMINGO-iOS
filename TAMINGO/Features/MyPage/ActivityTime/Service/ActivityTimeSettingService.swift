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
        let response = try await provider.requestAsync(.fetchActivityTime)

        let decoded = try JSONDecoder().decode(
            BaseResponse<ActivityTimeResponseDTO>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            throw APIError.server(
                status: 500,
                message: "조회 결과가 없습니다."
            )
        }

        return result.toDomain()
    }




    // MARK: - 저장
    func saveActivityTime(_ dto: ActivityTimeRequestDTO) async throws -> ActivityTime {
        let response = try await provider.requestAsync(.saveActivityTime(dto))

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

