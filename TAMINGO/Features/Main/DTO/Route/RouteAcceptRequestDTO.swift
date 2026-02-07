//
//  RouteAcceptRequestDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

struct RouteAcceptRequestDTO: Encodable {

    let baseScheduleId: Int
    let title: String
    let location: LocationDTO
    let requiredMinutes: Int

    struct LocationDTO: Encodable {
        let name: String
        let lat: Double
        let lng: Double
    }
}
