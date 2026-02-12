//
//  RouteDetour.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct RouteDetour {
    let suggestionId: Int
    let title: String
    let location: String
    let detourMinutes: Int
    let detourText: String
    let suggestionText: String
    
    let lat: Double
    let lng: Double
}
enum RouteDetourState {
    case normal      // 기본 (들르기/삭제 버튼 있음)
    case accepted    // 들르기 적용됨 (버튼 없음)
}
