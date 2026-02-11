//
//  TodoCategoryResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//


struct TodoCategoryResponseDTO: Decodable {
    let id: Int
    let name: String
    let colorCode: String
}

extension TodoCategoryResponseDTO {
    func toDomain() -> TodoCategory {
        TodoCategory(
            id: id,
            name: name,
            color: CategoryColor(rawValue: colorCode) ?? .mint
        )
    }
}
