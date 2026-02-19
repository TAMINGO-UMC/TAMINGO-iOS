//
//  RouteDetour.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct RouteDetour: Identifiable {
    let suggestionId: Int
    let title: String
    let location: String
    let detourMinutes: Int
    let detourText: String
    let suggestionText: String
    
    let lat: Double
    let lng: Double
    
    var state: RouteDetourState = .normal
    
    var id: Int { suggestionId }
}
enum RouteDetourState {
    case normal      // 기본 (들르기/삭제 버튼 있음)
    case accepted    // 들르기 적용됨 (버튼 없음)
}


extension RouteDetour {

    static func fromLinkedTodo(
        _ todo: LinkedTodo,
        previousDetours: [RouteDetour]
    ) -> RouteDetour {

        let previous = previousDetours.first {
            $0.suggestionId == todo.id
        }

        return RouteDetour(
            suggestionId: todo.id,
            title: todo.title,
            location: todo.placeName,
            detourMinutes: previous?.detourMinutes ?? 0,
            detourText: previous?.detourText ?? "경유 일정",
            suggestionText: previous?.suggestionText ?? "이 동선에서 들르면 좋아요",
            lat: previous?.lat ?? 0,
            lng: previous?.lng ?? 0,
            state: .accepted
        )
    }
}

