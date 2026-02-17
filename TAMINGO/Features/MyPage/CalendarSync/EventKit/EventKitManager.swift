//
//  EventKitManager.swift
//  TAMINGO
//
//  Created by 권예원 on 2/13/26.
//


import Foundation
import EventKit

enum EventKitError: LocalizedError {
    case permissionDenied

    var errorDescription: String? {
        return "캘린더 접근 권한이 필요합니다."
    }
}

// ios 17 이상만 지원되도록 구성
final class EventKitManager {

    private let store = EKEventStore()

    // MARK: - 권한 상태 확인

    func hasFullAccess() -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)

        if #available(iOS 17.0, *) {
            return status == .fullAccess
        } else {
            return status == .authorized
        }
    }

    // MARK: - 권한 요청

    func requestAccess() async throws {

        if #available(iOS 17.0, *) {
            try await store.requestFullAccessToEvents()
        } else {
            _ = try await store.requestAccess(to: .event)
        }

        guard hasFullAccess() else {
            throw EventKitError.permissionDenied
        }
    }

    // MARK: - 이벤트 조회

    func fetchEvents(start: Date, end: Date) throws -> [EKEvent] {

        guard hasFullAccess() else {
            throw EventKitError.permissionDenied
        }

        let predicate = store.predicateForEvents(
            withStart: start,
            end: end,
            calendars: nil
        )

        return store.events(matching: predicate)
            .sorted { $0.startDate < $1.startDate }
    }
}
