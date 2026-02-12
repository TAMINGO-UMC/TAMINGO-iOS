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
    
    private static let isoFormatter: ISO8601DateFormatter = {
            let f = ISO8601DateFormatter()
            f.formatOptions = [.withInternetDateTime]
            return f
       }()

    func toModel() -> RouteResultModel {
        RouteResultModel(
            totalDuration: totalDuration,
            startTime: Self.isoFormatter.date(from: startTime) ?? Date(),
            arriveTime: Self.isoFormatter.date(from: arriveTime) ?? Date(),
            startPlaceName: startPlaceName,
            arrivePlaceName: arrivePlaceName,
            wayPoints: wayPoints.map { $0.toModel() },
            legs: legs.map { $0.toModel() }
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

