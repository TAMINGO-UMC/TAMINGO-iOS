//
//  CreatePlaceRequestDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 1/30/26.
//

// 마이페이지에서도 사용

struct CreatePlaceRequestDTO: Encodable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

extension Place {
    func toCreateRequestDTO() -> CreatePlaceRequestDTO {
        CreatePlaceRequestDTO(
            name: name,
            address: address,
            latitude: latitude,
            longitude: longitude
        )
    }
}


