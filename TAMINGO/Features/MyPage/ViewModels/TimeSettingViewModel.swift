//
//  TimeSettingViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import Foundation

//Mock Data
enum ActivityTimeMock {

    static let weekdayDefault = ActivityTime(
        startTime: "08:00".toTimeDate()!,
        endTime: "22:00".toTimeDate()!,
        activeDays: [.mon, .tue, .wed, .thu, .fri]
    )

    static let weekendOnly = ActivityTime(
        startTime: "10:00".toTimeDate()!,
        endTime: "18:00".toTimeDate()!,
        activeDays: [.sat, .sun]
    )
}

@Observable
final class TimeSettingViewModel{
    var startTime: Date
    var endTime: Date
    var activeDays: Set<Weekday>

    init(activityTime: ActivityTime = ActivityTimeMock.weekdayDefault) {
        self.startTime = activityTime.startTime
        self.endTime = activityTime.endTime
        self.activeDays = activityTime.activeDays
    }
}
