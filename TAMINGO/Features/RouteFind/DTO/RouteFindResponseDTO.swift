//
//  RouteFindResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

struct RouteFindResponseDTO: Decodable {
    let totalDuration: Int
    let startTime: String
    let arriveTime: String
    let startPlaceName: String
    let arrivePlaceName: String
    let wayPoints: [String]
    let legs: [RouteLegDTO]
}

extension RouteFindResponseDTO {

    func toModel() -> RouteResultModel {
        RouteResultModel(
            totalDuration: totalDuration,
            startTime: ISO8601DateFormatter().date(from: startTime) ?? Date(),
            arriveTime: ISO8601DateFormatter().date(from: arriveTime) ?? Date(),
            startPlaceName: startPlaceName,
            arrivePlaceName: arrivePlaceName,
            wayPoints: wayPoints,
            legs: legs.compactMap { $0.toModel() }
        )
    }
}
