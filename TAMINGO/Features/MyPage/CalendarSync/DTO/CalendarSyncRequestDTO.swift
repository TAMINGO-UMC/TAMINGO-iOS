//
//  CalendarSyncRequestDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/12/26.
//

import Foundation

struct CalendarSyncRequestDTO: Encodable {
    let events: [CalendarEventDTO]
}

struct CalendarEventDTO: Encodable {
    let externalEventUid: String
    let title: String
    let startAt: String
    let endAt: String
    let location: String?
    let isAllDay: Bool
}
