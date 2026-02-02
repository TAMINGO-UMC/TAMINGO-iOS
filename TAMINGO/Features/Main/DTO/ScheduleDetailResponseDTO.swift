//
//  ScheduleDetailResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct ScheduleDetailResponseDTO: Decodable {
    let scheduleId: Int
    let title: String
    let startTime: String
    let duration: Int
    let location: LocationDTO
    let travelInfo: TravelInfoDTO
    let recommendedTodo: RecommendedTodoDTO?
}

extension ScheduleDetailResponseDTO {

    func toModel(nowRemainingMinutes: Int) -> ScheduleDetail {

        let departureStatus: DepartureStatus

        switch travelInfo.departureStatus {

        case .now:
            departureStatus = .now(
                remainingMinutes: nowRemainingMinutes
            )

        case .ready, .waiting:
            departureStatus = .preparing(
                remainingMinutes: nowRemainingMinutes
            )

        case .late:
            if let delay = travelInfo.delayMinutes, delay > 0 {
                departureStatus = .late(
                    remainingMinutes: nowRemainingMinutes,
                    delayMinutes: delay
                )
            } else {
                departureStatus = .delayed(
                    remainingMinutes: nowRemainingMinutes
                )
            }
        }

        return ScheduleDetail(
            id: scheduleId,
            title: title,
            startTime: startTime,
            duration: duration,
            location: location.toModel(),
            travel: TravelInfo(
                expectedTravelMinutes: travelInfo.expectedTravelMinutes,
                departureTime: travelInfo.recommendedDepartureTime,
                arrivalTime: travelInfo.recommendedArrivalTime,
                status: departureStatus
            ),
            recommendedTodo: recommendedTodo?.toModel()
        )
    }
}
