//
//  CalendarSyncViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import Foundation
import EventKit

@MainActor
@Observable
final class CalendarSyncViewModel {

    private let service: CalendarSyncServiceProtocol
    private let eventKitManager = EventKitManager()

    // MARK: - State

    var isLinked: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?
    var lastSyncedAt: String?

    init(service: CalendarSyncServiceProtocol) {
        self.service = service
    }

    // MARK: - 연동 상태 조회

    func loadConnectionStatus() async {
        do {
            isLoading = true
            let result = try await service.fetchConnectionStatus()
            isLinked = result.enabled
            lastSyncedAt = result.lastSyncedAt
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - 연동 토글

    func toggleLink(_ isOn: Bool) async {
        do {
            isLoading = true

            let result = try await service.updateConnectionStatus(enabled: isOn)
            isLinked = result.enabled

            if isOn {
                await syncNow()
            }

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - 수동 동기화

    func syncNow() async {
        do {
            try await eventKitManager.requestAccess()

            let start = Date().startOfDay
            let end = Calendar.current.date(byAdding: .month, value: 1, to: start)!

            let events = try eventKitManager.fetchEvents(start: start, end: end)
            let dtoList = events.map { $0.toDTO() }

            let result = try await service.sync(events: dtoList)
            lastSyncedAt = result.syncedAt

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
