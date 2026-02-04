//
//  PlaceUIModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import Foundation

struct PlaceUIModel: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let weeklyVisitCount: Int
    let isAISuggested: Bool
}
