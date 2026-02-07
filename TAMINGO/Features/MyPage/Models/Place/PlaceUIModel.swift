//
//  PlaceUIModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import Foundation

struct PlaceUIModel: Identifiable {
    let id: Int
    let name: String
    let address: String
    let weeklyVisitCount: Int
    let isAISuggested: Bool
}

extension PlaceUIModel {
    init(place: Place) {
        self.init(
            id: place.id,
            name: place.name,
            address: place.address,
            weeklyVisitCount: 0,
            isAISuggested: false
        )
    }
}
