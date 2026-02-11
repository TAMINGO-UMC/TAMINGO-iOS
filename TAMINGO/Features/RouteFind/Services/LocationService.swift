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

    // 1시간 전 1회 체크
    func silentGPS(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) async throws -> SilentGPSResponseDTO {

        let response: BaseResponse<SilentGPSResponseDTO> =
            try await provider.request(.silentGPS(
                scheduleId: scheduleId,
                latitude: latitude,
                longitude: longitude
            ))

        guard let result = response.result else {
            throw NSError(domain: "SilentGPS", code: -1)
        }

        return result
    }

    // 실시간 위치 전송
    func sendRealtime(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) async throws -> Bool {

        let response: BaseResponse<RealtimeGPSResponseDTO> =
            try await provider.request(.realtime(
                scheduleId: scheduleId,
                latitude: latitude,
                longitude: longitude
            ))

        return response.result?.isArrived ?? false
    }

    // 사후 확인
    func postCheck(scheduleId: Int) async throws {

        let _: BaseResponse<EmptyResponse> =
            try await provider.request(.postCheck(scheduleId: scheduleId))
    }
}

struct EmptyResponse: Decodable {}
