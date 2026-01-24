//
//  Category.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import Foundation

struct Category: Identifiable {
    let id: Int
    var name: String
    var type: CategoryType
    var icon: CategoryIcon
}

enum CategoryType {
    case schedule
    case todo
}

enum CategoryIcon: String, CaseIterable {
    case calendar
    case workout
    case study
    case star
    case briefcase

    var assetName: String {
        "icon_\(rawValue)"
    }
}

