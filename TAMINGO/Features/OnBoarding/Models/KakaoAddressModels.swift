//
//  KakaoAddressModels.swift
//  TAMINGO
//
//  Created by 권예원 on 1/30/26.
//

import Foundation

struct AddressResponse: Decodable {
    let documents: [AddressDocument]
}

struct AddressDocument: Decodable, Identifiable {
    let id = UUID()

    let address_name: String
    let x: String   // 경도
    let y: String   // 위도
    let address: AddressDetail?
    let road_address: RoadAddress?

    enum CodingKeys: String, CodingKey {
        case address_name
        case x, y
        case address
        case road_address
    }
}

struct AddressDetail: Decodable {
    let address_name: String
}

struct RoadAddress: Decodable {
    let address_name: String
}


extension AddressDocument {
    func toPlace() -> Place? {
        guard
            let latitude = Double(y),
            let longitude = Double(x)
        else { return nil }

        return Place(
            name: road_address?.address_name ?? address_name,
            address: address_name,
            latitude: latitude,
            longitude: longitude
        )
    }
}

