//
//  RouteDetourDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/7/26.
//

import Foundation

struct RouteDetourDTO: Decodable {
    let suggestionId: Int
    let suggestionTitle: String
    let placeName: String
    let detourMinutes: String
    let recommendationMessage: String
}

extension RouteDetourDTO {
    func toModel(lat: Double = 0, lng: Double = 0) -> RouteDetour {

        let minutesInt = Int(detourMinutes) ?? 0

        return RouteDetour(
            suggestionId: suggestionId,
            title: suggestionTitle,
            location: placeName,
            detourMinutes: minutesInt,
            detourText: "+\(minutesInt)분 우회",
            suggestionText: recommendationMessage,
            lat: lat,
            lng: lng
        )
    }
}
