//
//  LocationService.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation
import Moya
import Alamofire

final class LocationService {

    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()

    private let provider: MoyaProvider<LocationTarget>

    init() {
        self.provider = MoyaProvider<LocationTarget>(session: session)
    }
    
    func silentGPS(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) async throws {
        
        let request = SilentGPSRequestDTO(
            scheduleId: scheduleId,
            latitude: latitude,
            longitude: longitude
        )
        
        let _: BaseResponse<SilentGPSResponseDTO?> =
        try await provider.request(.silentGPS(request))
        
        // result 없어도 성공이면 통과
    }
    
    
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
    
    func postCheck(scheduleId: Int) async throws -> Bool {
        let response: BaseResponse<EmptyResponse> =
            try await provider.request(.postCheck(scheduleId: scheduleId))

        return response.isSuccess
    }
}
