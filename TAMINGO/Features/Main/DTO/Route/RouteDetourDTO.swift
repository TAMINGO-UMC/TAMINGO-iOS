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
    let detourMinutes: Int
    let recommendationMessage: String
}

extension RouteDetourDTO {

    func toModel(lat: Double = 0, lng: Double = 0) -> RouteDetour {
        RouteDetour(
            id: suggestionId,
            title: suggestionTitle,
            location: placeName,
            detourMinutes: detourMinutes,
            detourText: "+\(detourMinutes)분 우회",
            suggestionText: recommendationMessage,
            lat: lat,
            lng: lng
        )
    }
}
