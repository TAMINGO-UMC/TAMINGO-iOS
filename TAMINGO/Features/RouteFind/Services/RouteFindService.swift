//
//  RouteFindService.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation
import Moya

final class RouteFindService {

    private let provider = MoyaProvider<RouteFindTarget>()

    // START
    func start(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) async throws -> RouteResultModel {

        let request = RouteFindStartRequestDTO(
            scheduleId: scheduleId,
            latitude: latitude,
            longitude: longitude
        )

        let response: BaseResponse<RouteFindStartResponseDTO> =
            try await provider.request(.start(request))

        guard let result = response.result else {
            throw NSError(
                domain: "RouteFindService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Start result is nil"]
            )
        }

        return result.toModel()
    }

    // END
    func end(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) async throws -> Bool {

        let request = RouteFindEndRequestDTO(
            scheduleId: scheduleId,
            latitude: latitude,
            longitude: longitude
        )

        let response: BaseResponse<RouteFindEndResponseDTO> =
            try await provider.request(.end(request))

        guard let result = response.result else {
            throw NSError(
                domain: "RouteFindService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "End result is nil"]
            )
        }

        return result.isArrived
    }
}
