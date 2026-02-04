//
//  FrequentPlacesViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import Foundation
import Observation

@Observable
final class FrequentPlacesViewModel {


    var places: [PlaceUIModel] = [
        .init(
            name: "집",
            address: "서울시 노원구 광운로 21",
            weeklyVisitCount: 6,
            isAISuggested: false
        ),
        .init(
            name: "중앙도서관",
            address: "서울시 노원구 광운로 21",
            weeklyVisitCount: 6,
            isAISuggested: true
        )
    ]

    func deletePlace(_ place: PlaceUIModel) {
        places.removeAll { $0.id == place.id }
    }

    func editPlace(_ place: PlaceUIModel) {
        // TODO: 수정 화면 연결
    }

    func addPlace() {
        // TODO: 장소 추가 화면 연결
    }
}
