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

    // 🔥 서버 연동 객체들 (임시 비활성화)
//    private let routeService = RouteFindService()
//    private let locationService = LocationService()
//    private let locationManager = LocationManager.shared

    private var timer: Timer?

    init(scheduleId: Int) {
        self.scheduleId = scheduleId
    }

    // MARK: - Start Route (Mock 모드)
    func startRoute() async {
        state = .loading

        // 🔥 서버 호출 부분 임시 주석
//        do {
//            let coord = try await locationManager.requestCurrentCoordinate()
//
//            let result = try await routeService.start(
//                scheduleId: scheduleId,
//                latitude: coord.latitude,
//                longitude: coord.longitude
//            )
//
//            self.routeResult = result
//            self.state = .navigating
//
//            startRealtime()
//
//        } catch {
//            state = .error(error.localizedDescription)
//        }

        // 🔥 Mock 동작
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        self.routeResult = RouteResultModel.preview
        self.state = .navigating

        startRealtime()
    }

    // MARK: - Realtime GPS (Mock 모드)
    private func startRealtime() {
        stopRealtime()

        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let self else { return }

            print("📍 Mock realtime update")

            // 🔥 실제 서버 호출 주석
//            Task {
//                do {
//                    let coord = try await locationManager.requestCurrentCoordinate()
//
//                    let isArrived = try await locationService.sendRealtime(
//                        scheduleId: self.scheduleId,
//                        latitude: coord.latitude,
//                        longitude: coord.longitude
//                    )
//
//                    if isArrived {
//                        self.state = .arrived
//                        self.stopRealtime()
//                    }
//
//                } catch {
//                    print("Realtime error:", error)
//                }
//            }
        }
    }

    func stopRealtime() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - End Route (Mock 모드)
    func endRoute() async {
        state = .loading
        stopRealtime()

        // 🔥 실제 서버 호출 주석
//        do {
//            let coord = try await locationManager.requestCurrentCoordinate()
//
//            let isArrived = try await routeService.end(
//                scheduleId: scheduleId,
//                latitude: coord.latitude,
//                longitude: coord.longitude
//            )
//
//            if isArrived {
//                state = .ended
//            } else {
//                state = .navigating
//            }
//
//        } catch {
//            state = .error(error.localizedDescription)
//        }

        // 🔥 Mock 종료 처리
        try? await Task.sleep(nanoseconds: 800_000_000)
        state = .ended
    }
}
