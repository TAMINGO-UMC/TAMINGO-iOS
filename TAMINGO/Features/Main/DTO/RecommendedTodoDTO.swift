//
//  RecommendedTodoDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct RecommendedTodoDTO: Decodable {
    let location: LocationDTO
    let detourMinutes: Int
}

extension RecommendedTodoDTO {

    func toModel() -> RouteTodo {
        RouteTodo(
            location: location.toModel(),
            detourMinutes: detourMinutes
        )
    }
}
