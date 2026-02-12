//
//  RouteFindResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

struct RouteFindStartResponseDTO: Decodable {
    let totalDuration: Int
    let startTime: String
    let arriveTime: String
    let startPlaceName: String
    let arrivePlaceName: String
    let wayPoints: [WayPointDTO]
    let legs: [RouteLegDTO]
}

struct WayPointDTO: Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
    let order: Int
}

extension RouteFindStartResponseDTO {

    func toModel() -> RouteResultModel {
        RouteResultModel(
            totalDuration: totalDuration,
            startTime: ISO8601DateFormatter().date(from: startTime) ?? Date(),
            arriveTime: ISO8601DateFormatter().date(from: arriveTime) ?? Date(),
            startPlaceName: startPlaceName,
            arrivePlaceName: arrivePlaceName,
            wayPoints: wayPoints.map { $0.toModel() },
            legs: legs.compactMap { $0.toModel() }
        )
    }
}

extension WayPointDTO {
    func toModel() -> WayPointModel {
        WayPointModel(
            name: name,
            latitude: latitude,
            longitude: longitude,
            order: order
        )
    }
}

