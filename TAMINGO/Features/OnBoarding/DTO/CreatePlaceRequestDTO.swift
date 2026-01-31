//
//  CreatePlaceRequestDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 1/30/26.
//

struct CreatePlaceRequestDTO: Encodable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}
