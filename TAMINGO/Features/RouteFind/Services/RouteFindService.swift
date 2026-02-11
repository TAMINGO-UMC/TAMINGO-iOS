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

    func startRouteFind(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) async throws -> RouteResultModel {

        let response: BaseResponse<RouteFindResponseDTO> =
            try await provider.request(
                .startRouteFind(
                    scheduleId: scheduleId,
                    latitude: latitude,
                    longitude: longitude
                )
            )

        guard let dto = response.result else {
            throw NSError(
                domain: "RouteFindService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Route result is nil"]
            )
        }

        return dto.toModel()
    }
}
