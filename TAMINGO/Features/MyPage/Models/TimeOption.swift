//
//  TimeOption.swift
//  TAMINGO
//
//  Created by 권예원 on 2/7/26.
//

import Foundation

struct TimeOption: Identifiable, Equatable {
    let id: Int
    let hour: Int       

    var title: String {
        String(format: "%02d:00", hour)
    }

    var date: Date {
        let calendar = Calendar.current
        return calendar.date(
            bySettingHour: hour == 24 ? 0 : hour,
            minute: 0,
            second: 0,
            of: Date()
        )!
    }
}
