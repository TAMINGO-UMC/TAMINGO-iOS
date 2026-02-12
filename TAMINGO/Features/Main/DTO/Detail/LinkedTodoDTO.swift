//
//  LinkedTodoDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/7/26.
//

import Foundation

struct LinkedTodoDTO: Decodable {
    let todoId: Int
    let title: String
    let placeName: String
}

extension LinkedTodoDTO {

    func toModel() -> LinkedTodo {
        LinkedTodo(
            id: todoId,
            title: title,
            placeName: placeName
        )
    }
}
