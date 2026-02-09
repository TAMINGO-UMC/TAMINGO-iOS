//
//  RouteTodo.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct RouteTodo {
    let location: Location
    let detourMinutes: Int
}

extension RouteTodo {

    func toRouteLink() -> RouteLink {
        RouteLink(
            title: "\(location.name) 들르기",
            location: location.name,
            detourText: "+\(detourMinutes)분 우회",
            suggestionText: "가는 길에 잠깐 들를 수 있어요"
        )
    }
}

