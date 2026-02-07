//
//  RouteLink.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct RouteLink {
    let title: String
    let location: String
    let detourText: String
    let suggestionText: String
}

enum RouteLinkState {
    case normal      // 기본 (들르기/삭제 버튼 있음)
    case accepted    // 들르기 적용됨 (버튼 없음)
}
