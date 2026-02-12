//
//  HomeDetailService.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation
import Moya

final class HomeDetailService {
    
    private let provider = MoyaProvider<HomeDetailTarget>()
    
    func fetchDetail(scheduleId: Int) async throws -> ScheduleDetail {
        let decoded: ScheduleDetailResponseDTO =
        try await provider.request(.detail(scheduleId: scheduleId))
        
        guard decoded.isSuccess else {
            throw NSError(domain: "Detail", code: -1, userInfo: [NSLocalizedDescriptionKey: decoded.message])
        }
        
        guard let result = decoded.result else {
            throw NSError(domain: "Detail", code: -1, userInfo: [NSLocalizedDescriptionKey: "결과 데이터가 없습니다."])
        }
        
        return result.toModel()
    }
    
    func acceptRoute(
        suggestionId: Int,
        request: RouteAcceptRequestDTO
    ) async throws {
        
        let _: BaseResponse<EmptyResponse> =
            try await provider.request(
                .acceptRoute(
                    suggestionId: suggestionId,
                    request: request
                )
            )
    }
    
    func rejectRoute(suggestionId: Int) async throws {
        let _: BaseResponse<EmptyResponse> =
        try await provider.request(.rejectRoute(suggestionId: suggestionId))
    }
}

struct EmptyResponse: Decodable {}
