//
//  LocationService.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation
import Moya

final class LocationService {

    private let provider = MoyaProvider<LocationTarget>()

    func sendRealtime(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) async throws -> Bool {

        let request = RealtimeGPSRequestDTO(
            scheduleId: scheduleId,
            latitude: latitude,
            longitude: longitude
        )

        let response: BaseResponse<RouteFindEndResponseDTO> =
            try await provider.request(.realtime(request))

        guard let result = response.result else {
            throw NSError(
                domain: "LocationService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Realtime result is nil"]
            )
        }

        return result.isArrived
    }
}
