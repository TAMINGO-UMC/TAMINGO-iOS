//
//  DepartureTimeViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/19/26.
//

import Foundation

@Observable
final class DepartureTimeViewModel {
    let departureTime: Date
    private var timer: Timer?

    var remainingSeconds: Int = 0

    init(departureTime: Date) {
        self.departureTime = departureTime
        start()
    }

    func start() {
        update()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.update()
        }
    }

    private func update() {
        remainingSeconds = Int(departureTime.timeIntervalSinceNow)
    }
}
