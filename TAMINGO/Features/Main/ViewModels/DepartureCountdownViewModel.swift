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

    // MARK: - Inputs
    private let departureDate: Date
    private let status: DepartureStatus

    // MARK: - Timer
    private var timer: Timer?

    // MARK: - State
    var remainingMinutes: Int = 0

    init(
        departureDate: Date,
        status: DepartureStatus
    ) {
        self.departureDate = departureDate
        self.status = status
        update()
        start()
    }

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

    // MARK: - UI Formatting

    /// ✅ 규칙:
    /// - 기본: "0시간 5분" 포함해서 무조건 시간 표시
    /// - 주황/빨강(지연): "-0시간 5분" 형태로 항상 마이너스 표시
    var timeText: String {
        let absM = abs(remainingMinutes)
        let h = absM / 60
        let m = absM % 60

        let base = "\(h)시간 \(m)분"

        if status.isDelayStyle {
            // 주황/빨강은 "지연" 강조 목적이라 항상 '-'로 보이게 고정
            return "-\(base)"
        } else {
            // 정상 상태에서는 실제 남은 시간이 음수면 -로 표시(안전장치)
            return remainingMinutes < 0 ? "-\(base)" : base
        }
    }
}
