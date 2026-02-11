//
//  TodoCategoryDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/3/26.
//

import SwiftUI

struct CategoryResponseDTO: Decodable {
    let id: Int
    let name: String
    let colorCode: String
}

extension CategoryResponseDTO {
    func toDomain() -> TodoCategory {
        let categoryColor = CategoryColor(rawValue: colorCode)

        return TodoCategory(
            id: id,
            name: name,
            color: categoryColor?.color ?? .mainMint,
            colorName: categoryColor?.displayName ?? "민트"
        )
    }
}


struct CreateTodoCategoryRequestDTO: Encodable {
    let name: String
    let colorCode: String
}

struct UpdateTodoCategoryRequestDTO: Encodable {
    let name: String
    let colorCode: String
}

