//
//  PersonalizationDTO.swift
//  TAMINGO
//
//  Created by 김도연 on 2/10/26.
//

import Foundation

struct PersonalizationSettings: Decodable, Encodable {
    let isErrorLogEnabled: Bool
}

struct PersonalizationSummaryDTO: Decodable {
    let patternCount: Int
    let avgAccuracy: Int
    let fvpCount: Int
}

struct PersonalizationDTO: Decodable, Hashable {
    let startPlace: String
    let arrivePlace: String
    let expectedDuration: Int
    let actualDuration: Int
    let errorMin: Int
}
