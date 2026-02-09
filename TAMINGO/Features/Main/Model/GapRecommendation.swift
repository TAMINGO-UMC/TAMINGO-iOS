//
//  GapRecommendation.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/1/26.
//

import Foundation

struct GapRecommendation: Identifiable {
    let id: Int              // suggestionId
    let location: String
    let time: String
    let requiredMinutes: Int
    let message: String
}
