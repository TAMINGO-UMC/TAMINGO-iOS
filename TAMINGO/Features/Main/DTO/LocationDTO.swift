//
//  LocationDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/2/26.
//

import Foundation

struct LocationDTO: Encodable, Decodable {
    let name: String
    let lat: Double
    let lng: Double
}

extension LocationDTO {
    func toModel() -> Location {
        Location(
            name: name,
            lat: lat,
            lng: lng
        )
    }
}
