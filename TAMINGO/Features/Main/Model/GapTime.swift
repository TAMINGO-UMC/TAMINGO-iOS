//
//  GapTime.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct GapTime: Identifiable, Hashable {
    let id: Int            // suggestionId
    let minutes: String
    let title: String
    let location: String
    let availableText: String

    let gapStartTime: String
    let gapEndTime: String
}


extension GapTime {
    var gapStartTimeText: String {
        String(gapStartTime.prefix(5))
    }
}
