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

    enum State: Equatable {
        case idle
        case loading
        case navigating

        case arrived
        case endingConfirm

        case ended
        case error(String)

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle),
                 (.loading, .loading),
                 (.navigating, .navigating),
                 (.arrived, .arrived),
                 (.endingConfirm, .endingConfirm),
                 (.ended, .ended):
                return true

            case (.error(let l), .error(let r)):
                return l == r

            default:
                return false
            }
        }
    }

    var state: State = .idle
    var routeResult: RouteResultModel?

    private let scheduleId: Int
    private let routeService = RouteFindService()
    private let locationService = LocationService()
    private let locationManager = LocationManager.shared

    private var realtimeTask: Task<Void, Never>?

    // 상태 플래그
    private var isEnding = false
    private var isManuallyEnded = false
    private var didShowArrivalPopup = false

    init(scheduleId: Int) {
        self.scheduleId = scheduleId
    }

    // MARK: - Start Route
    func startRoute() async {
        state = .loading

        do {
            let coord = try await locationManager.requestCurrentCoordinate()

            _ = try await locationService.silentGPS(
                scheduleId: scheduleId,
                latitude: coord.latitude,
                longitude: coord.longitude
            )

            let result = try await routeService.start(
                scheduleId: scheduleId,
                latitude: coord.latitude,
                longitude: coord.longitude
            )

            routeResult = result
            state = .navigating

            startRealtime()

        } catch {
            state = .error(error.localizedDescription)
        }
    }

    // MARK: - Realtime
    private func startRealtime() {
        stopRealtime()

        realtimeTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(600))
                guard let self else { return }

                guard !self.isManuallyEnded else { return }

                do {
                    let coord = try await self.locationManager.requestCurrentCoordinate()
                    let isArrived = try await self.locationService.sendRealtime(
                        scheduleId: self.scheduleId,
                        latitude: coord.latitude,
                        longitude: coord.longitude
                    )

                    if isArrived, !self.didShowArrivalPopup {
                        self.didShowArrivalPopup = true
                        self.state = .arrived
                        self.stopRealtime()
                    }

                } catch { }
            }
        }
    }

    func stopRealtime() {
        realtimeTask?.cancel()
        realtimeTask = nil
    }

    // MARK: - Manual End
    func endRouteManually() {
        isManuallyEnded = true
        stopRealtime()
        state = .ended
    }

    // MARK: - End Route (서버 통지만)
    func endRoute() async {
        stopRealtime()

        do {
            let coord = try await locationManager.requestCurrentCoordinate()
            _ = try await routeService.endRoute(
                scheduleId: scheduleId,
                latitude: coord.latitude,
                longitude: coord.longitude
            )
        } catch { }
    }

    // MARK: - Background check
    func checkArrivalAfterBackground() async {
        guard case .navigating = state else { return }
        guard !isManuallyEnded else { return }

        do {
            let isArrived = try await locationService.postCheck(scheduleId: scheduleId)
            if isArrived, !didShowArrivalPopup {
                didShowArrivalPopup = true
                state = .arrived
            }
        } catch { }
    }
}
