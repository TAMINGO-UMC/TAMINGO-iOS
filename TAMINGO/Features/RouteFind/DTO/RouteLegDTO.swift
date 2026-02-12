//
//  RouteLegDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

struct RouteLegDTO: Decodable {
    let mode: TransportModeDTO
    let sectionTime: Int
    let distance: Int

    // WALK
    let walkDescription: String?

    // SUBWAY / BUS
    let startName: String?
    let endName: String?
    let routeName: String?
    let routeColor: String?
    let stations: [String]?
    let stationCount: Int?
}

extension RouteLegDTO {

    func toModel() -> RouteLegModel {
        RouteLegModel(
            mode: mode.toModel(),
            sectionTime: sectionTime,
            distance: distance,
            walkDescription: walkDescription,
            startName: startName,
            endName: endName,
            routeName: routeName,
            routeColor: routeColor,
            stations: stations ?? [],
            stationCount: stationCount ?? 0,
            options: []
        )
    }
}
