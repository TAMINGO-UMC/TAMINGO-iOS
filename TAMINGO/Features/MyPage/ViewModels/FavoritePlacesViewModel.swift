//
//  TransportViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import Foundation

// Mock 데이터
enum FavoritePlaceMock {

    static let `default`: [FavoritePlace] = [
        FavoritePlace(
            id: 1,
            name: "집",
            address: "서울시 노원구 광운로 21",
            latitude: 37.61972,
            longitude: 127.05981,
            weeklyVisitCount: 6
        ),
        FavoritePlace(
            id: 2,
            name: "학교",
            address: "서울시 노원구 광운로 20",
            latitude: 37.61980,
            longitude: 127.05990,
            weeklyVisitCount: 6
        )
    ]

    static let empty: [FavoritePlace] = []
}


@Observable
final class FavoritePlaceViewModel {

    var places: [FavoritePlace]

    init(places: [FavoritePlace] = FavoritePlaceMock.default) {
        self.places = places
    }
}

