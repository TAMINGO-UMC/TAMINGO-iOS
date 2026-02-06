//
//  ActivityTimeDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import Foundation

struct ActivityTimeDTO: Decodable {
    let startTime: String
    let endTime: String
    let monEnabled: Bool
    let tueEnabled: Bool
    let wedEnabled: Bool
    let thuEnabled: Bool
    let friEnabled: Bool
    let weekendEnabled: Bool
}

extension ActivityTimeDTO {

    func toDomain() -> ActivityTime? {
        guard
            let start = startTime.toTimeDate(),
            let end = endTime.toTimeDate()
        else {
            return nil
        }

        return ActivityTime(
            startTime: start,
            endTime: end,
            activeDays: activeWeekdays()
        )
    }


    private func activeWeekdays() -> Set<Weekday> {
        var days: Set<Weekday> = []

        if monEnabled { days.insert(.mon) }
        if tueEnabled { days.insert(.tue) }
        if wedEnabled { days.insert(.wed) }
        if thuEnabled { days.insert(.thu) }
        if friEnabled { days.insert(.fri) }

        if weekendEnabled {
            days.insert(.sat)
            days.insert(.sun)
        }

        return days
    }
}

