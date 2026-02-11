//
//  RouteFindViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation
internal import _LocationEssentials

@Observable
final class RouteFindViewModel {

    private let service = LocationService()
    private let locationManager = LocationManager()

    private var timer: Timer?

    func startTracking(scheduleId: Int) {

        locationManager.onUpdate = { [weak self] coordinate in
            self?.send(scheduleId: scheduleId,
                       lat: coordinate.latitude,
                       lng: coordinate.longitude)
        }

        locationManager.start()

        timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { _ in
            self.locationManager.start()
        }
    }

    private func send(scheduleId: Int, lat: Double, lng: Double) {

        Task {
            let arrived = try await service.sendRealtime(
                scheduleId: scheduleId,
                latitude: lat,
                longitude: lng
            )

            if arrived {
                stopTracking()
            }
        }
    }

    func stopTracking() {
        timer?.invalidate()
        locationManager.stop()
    }
}
