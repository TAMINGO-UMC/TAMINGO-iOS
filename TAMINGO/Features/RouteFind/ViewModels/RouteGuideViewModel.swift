//
//  RouteGuideViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/12/26.
//

import Foundation
import CoreLocation
import Observation

@Observable
@MainActor
final class RouteGuideViewModel {

    enum State {
        case idle
        case loading
        case navigating
        case arrived
        case ended
        case error(String)
    }

    var state: State = .idle
    var routeResult: RouteResultModel?

    private let scheduleId: Int
    private let routeService = RouteFindService()
    private let locationService = LocationService()
    private let locationManager = LocationManager.shared

    private var realtimeTask: Task<Void, Never>?

    init(scheduleId: Int) {
        self.scheduleId = scheduleId
    }

    // MARK: - Start Route
    func startRoute() async {
        state = .loading

        do {
            let coord = try await locationManager.requestCurrentCoordinate()

            let result = try await routeService.start(
                scheduleId: scheduleId,
                latitude: coord.latitude,
                longitude: coord.longitude
            )

            self.routeResult = result
            self.state = .navigating

            startRealtime()

        } catch {
            state = .error(error.localizedDescription)
        }
    }

    // MARK: - Realtime GPS
    private func startRealtime() {
        stopRealtime()
        
        realtimeTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(600))
                guard let self, !Task.isCancelled else { break }
                
                do {
                    let coord = try await self.locationManager.requestCurrentCoordinate()
                    let isArrived = try await self.locationService.sendRealtime(
                        scheduleId: self.scheduleId,
                        latitude: coord.latitude,
                        longitude: coord.longitude
                    )
                    if isArrived {
                        self.state = .arrived
                        self.stopRealtime()
                    }
                } catch {
                    print("Realtime error:", error)
                }
            }
        }
    }
    
    func stopRealtime() {
        realtimeTask?.cancel()
        realtimeTask = nil
    }

    // MARK: - End Route
    func endRoute() async {
        state = .loading
        stopRealtime()

        do {
            let coord = try await locationManager.requestCurrentCoordinate()

            let isArrived = try await routeService.end(
                scheduleId: scheduleId,
                latitude: coord.latitude,
                longitude: coord.longitude
            )

            if isArrived {
                state = .ended
            } else {
                state = .navigating
                startRealtime()
            }

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
