//
//  EventKit.swift
//  TAMINGO
//
//  Created by 권예원 on 2/13/26.
//

import EventKit

extension EKEvent {

    func toDTO() -> CalendarEventDTO {
        CalendarEventDTO(
            externalEventUid: self.calendarItemIdentifier,
            title: self.title ?? "",
            startAt: self.startDate,
            endAt: self.endDate,
            location: self.location,
            isAllDay: self.isAllDay
        )
    }
}
