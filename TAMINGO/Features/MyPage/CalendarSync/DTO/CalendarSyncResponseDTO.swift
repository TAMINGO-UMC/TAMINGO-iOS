//
//  CalendarSyncResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/12/26.
//

import Foundation

struct CalendarSyncResultDTO: Decodable {
    let createdSchedules: Int
    let updatedSchedules: Int
    let skippedSchedules: Int
    let upsertedEvents: Int
    let syncedAt: String
}
