//
//  HomeService.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/7/26.
//

import Foundation
import Moya

final class HomeService {

    private let provider = MoyaProvider<HomeTarget>()

    func fetchTodayTimeline() async throws -> HomeScheduleResponseDTO {
        let decoded: HomeScheduleResponseDTO =
            try await provider.request(.today)
        return decoded
    }

    func acceptSuggestion(id: Int) async throws {
        _ = try await provider.requestAsync(.acceptSuggestion(id: id))
    }

    func rejectSuggestion(id: Int) async throws {
        _ = try await provider.requestAsync(.rejectSuggestion(id: id))
    }
}
