//
//  FavoritePlace.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import Foundation

struct FavoritePlace: Identifiable {
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let weeklyVisitCount: Int
}
