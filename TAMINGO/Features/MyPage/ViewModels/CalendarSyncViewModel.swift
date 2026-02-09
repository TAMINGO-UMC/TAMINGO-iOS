//
//  CalendarSyncViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import Foundation
import EventKit

@Observable
final class CalendarSyncViewModel {

    // MARK: - State
    var isLinked: Bool = true
    var isSyncing: Bool = true

    var syncToApple: Bool = true
    var syncFromApple: Bool = true   // 추후


    func toggleSyncToApple(_ isOn: Bool) {
        syncToApple = isOn
        // TODO: TAMINGO → Apple
    }

    func toggleSyncFromApple(_ isOn: Bool) {
        syncFromApple = isOn
        // TODO: (추후) Apple → TAMINGO
    }

    func disconnect() {
        isLinked = false
        isSyncing = false
        syncToApple = false
        syncFromApple = false

        // TODO: EventKit 캘린더
    }
}
