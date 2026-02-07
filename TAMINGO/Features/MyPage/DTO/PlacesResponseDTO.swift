//
//  PlacesResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//


import Foundation

struct PlacesResponseDTO: Decodable {
    let places: [PlaceDTO]
}

struct PlaceDTO: Decodable {
    let placeId: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let weeklyVisitCount: Int
}

extension PlaceDTO {
    func toFavoritePlace() -> FavoritePlace {
        FavoritePlace(
            id: placeId,
            name: name,
            address: address,
            latitude: latitude,
            longitude: longitude,
            weeklyVisitCount: weeklyVisitCount
        )
    }
}
