//
//  ScheduleDetailResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct ScheduleDetailResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ScheduleDetailResultDTO?
}



struct ScheduleDetailResultDTO: Decodable {
    let scheduleStatus: ScheduleStatusDTO
    let linkedTodos: [LinkedTodoDTO]
    let routeDetourRecommendations: [RouteDetourDTO]
}

extension ScheduleDetailResultDTO {
    func toModel() -> ScheduleDetail {
        ScheduleDetail(
            travel: scheduleStatus.toTravelStatus(),
            linkedTodos: linkedTodos.map { $0.toModel() },
            detourRecommendations: routeDetourRecommendations.map { $0.toModel() },
        )
    }
}
