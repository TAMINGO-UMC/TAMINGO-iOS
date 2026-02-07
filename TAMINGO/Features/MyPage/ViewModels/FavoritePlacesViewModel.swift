//
//  FrequentPlacesViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import Foundation
import Observation

extension PlaceUIModel {

    static let mock: [PlaceUIModel] = [
        .init(
            id: 1,
            name: "집",
            address: "서울시 노원구 광운로 21",
            weeklyVisitCount: 6,
            isAISuggested: false
        ),
        .init(
            id: 2,
            name: "중앙도서관",
            address: "서울시 노원구 광운로 21",
            weeklyVisitCount: 6,
            isAISuggested: true
        )
    ]
}

@Observable
final class FavoritePlacesViewModel {

    var places: [PlaceUIModel]

    init(places: [PlaceUIModel] = PlaceUIModel.mock) {
        self.places = places
    }

    func deletePlace(_ place: PlaceUIModel) {
        places.removeAll { $0.id == place.id }
    }

    func editPlace(_ place: PlaceUIModel) {
        // TODO: 수정 화면 연결
    }

    func addPlace(_ place: Place) {
        let uiModel = PlaceUIModel(place: place)
        places.append(uiModel)
    }
}

