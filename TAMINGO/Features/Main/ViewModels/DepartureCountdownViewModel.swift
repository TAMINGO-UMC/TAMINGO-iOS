//
//  DepartureCountdownViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/19/26.
//

import Foundation
import Observation

@Observable
final class DepartureCountdownViewModel {

    // MARK: - Core
    let departureDate: Date
    private var timer: Timer?

    var remainingMinutes: Int = 0

    // MARK: - Init
    init(departureDate: Date) {
        self.departureDate = departureDate
        update()
        start()
    }

    // MARK: - Timer
    private func start() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 60,
            repeats: true
        ) { [weak self] _ in
            self?.update()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func update() {
        let diffSeconds = Int(departureDate.timeIntervalSinceNow)
        remainingMinutes = diffSeconds / 60
    }

    deinit {
        stop()
    }

    // MARK: - UI 전용 계산
    var timeText: String {
        let m = abs(remainingMinutes)
        let h = m / 60
        let min = m % 60

        if h > 0 {
            return "\(h)시간 \(min)분"
        } else {
            return "\(min)분"
        }
    }

    var subTimeText: String? {
        remainingMinutes < 0
        ? "(\(abs(remainingMinutes))분 지각)"
        : nil
    }

    /// DepartureStatus → 기존 UI 그대로 사용
    var derivedStatus: DepartureStatus {
        let m = remainingMinutes

        if m < 0 {
            return .late(
                remainingMinutes: abs(m),
                delayMinutes: abs(m)
            )
        } else if m <= 10 {
            return .now(remainingMinutes: m)
        } else {
            return .preparing(remainingMinutes: m)
        }
    }
}

// MARK: - Utils
extension DepartureCountdownViewModel {

    static func todayDate(from timeString: String) -> Date {
        let now = Date()
        let calendar = Calendar.current

        let parts = timeString
            .split(separator: ":")
            .compactMap { Int($0) }

        let hour = parts[safe: 0] ?? 0
        let minute = parts[safe: 1] ?? 0
        let second = parts[safe: 2] ?? 0

        return calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: second,
            of: now
        )!
    }
}

