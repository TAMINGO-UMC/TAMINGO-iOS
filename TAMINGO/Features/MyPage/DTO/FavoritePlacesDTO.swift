//
//  FavoritePlacesDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//


struct FavoritePlaceDTO: Codable {
    let placeId: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let weeklyVisitCount: Int
}

typealias FavoritePlacesDTO = [FavoritePlaceDTO]


extension FavoritePlaceDTO {
    func toDomain() -> FavoritePlace {
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

// 배열 변환용
extension Array where Element == FavoritePlaceDTO {
    func toDomain() -> [FavoritePlace] {
        map { $0.toDomain() }
    }
}
