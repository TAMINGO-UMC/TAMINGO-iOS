//
//  ScheduleCategoryResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

struct ScheduleCategoryResponseDTO: Decodable {
    let id: Int
    let name: String
    let colorCode: String
}

extension ScheduleCategoryResponseDTO {
    
    func toDomain() -> ScheduleCategory {
        ScheduleCategory(
            id: id,
            name: name,
            color: CategoryColor(rawValue: colorCode) ?? .mint
        )
    }
}
