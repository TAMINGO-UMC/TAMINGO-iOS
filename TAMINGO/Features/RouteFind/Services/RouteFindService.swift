//
//  RouteFindService.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation
import Moya

final class RouteFindService {

    private let provider = MoyaProvider<RouteFindTarget>(
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
    )

    // START
    func start(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) async throws -> RouteResultModel {

        let requestDTO = RouteFindStartRequestDTO(
            scheduleId: scheduleId,
            latitude: latitude,
            longitude: longitude
        )

        print("🚀 START REQUEST")
        print("scheduleId:", scheduleId)
        print("latitude:", latitude)
        print("longitude:", longitude)

        return try await withCheckedThrowingContinuation { continuation in

            provider.request(.start(requestDTO)) { result in

                switch result {

                case .success(let response):

                    print("📡 STATUS:", response.statusCode)

                    if let body = String(data: response.data, encoding: .utf8) {
                        print("📡 BODY:", body)
                    }

                    do {
                        let decoder = JSONDecoder()
                           decoder.dateDecodingStrategy = .formatted(
                               RouteDateFormatter.isoWithNanoSeconds
                           )

                           let decoded = try decoder.decode(
                               BaseResponse<RouteFindStartResponseDTO>.self,
                               from: response.data
                           )

                        guard let result = decoded.result else {
                            throw NSError(
                                domain: "RouteFindService",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Start result is nil"]
                            )
                        }

                        continuation.resume(returning: result.toModel())

                    } catch {
                        continuation.resume(throwing: error)
                    }

                case .failure(let error):
                    print("❌ NETWORK ERROR:", error)
                    continuation.resume(throwing: error)
                }
            }
        }
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
