//
//  ActivityTimeResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/9/26.
//

import Foundation

struct ActivityTimeResponseDTO: Decodable {
    let startTime: String
    let endTime: String
    let monEnabled: Bool
    let tueEnabled: Bool
    let wedEnabled: Bool
    let thuEnabled: Bool
    let friEnabled: Bool
    let weekendEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case startTime
        case endTime
        case monEnabled = "mon"
        case tueEnabled = "tue"
        case wedEnabled = "wed"
        case thuEnabled = "thu"
        case friEnabled = "fri"
        case weekendEnabled = "weekend"
    }
}



extension ActivityTimeResponseDTO {
    func toDomain() -> ActivityTime {
        ActivityTime(
            startTime: startTime.toTimeOnlyDate() ?? Date(),
            endTime: endTime.toTimeOnlyDate() ?? Date(),
            activeDays: Set<Weekday>.from(
                mon: monEnabled,
                tue: tueEnabled,
                wed: wedEnabled,
                thu: thuEnabled,
                fri: friEnabled,
                weekend: weekendEnabled
            )
        )
    }
}


