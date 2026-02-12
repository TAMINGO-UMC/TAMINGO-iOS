//
//  ActivityTimeRequestDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//


struct ActivityTimeRequestDTO: Encodable {
    let startTime: String
    let endTime: String
    let mon: Bool
    let tue: Bool
    let wed: Bool
    let thu: Bool
    let fri: Bool
    let weekend: Bool
}

extension ActivityTime {
    func toDTO() -> ActivityTimeRequestDTO {
        ActivityTimeRequestDTO(
            startTime: startTime.toString(format: "HH:mm:ss"),
            endTime: endTime.toString(format: "HH:mm:ss"),
            mon: activeDays.contains(.mon),
            tue: activeDays.contains(.tue),
            wed: activeDays.contains(.wed),
            thu: activeDays.contains(.thu),
            fri: activeDays.contains(.fri),
            weekend: activeDays.contains(.sat) && activeDays.contains(.sun)
        )
    }
}

