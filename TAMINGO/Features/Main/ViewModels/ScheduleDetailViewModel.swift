//
//  ScheduleDetailViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/7/26.
//

import Foundation
import Observation

@Observable
final class ScheduleDetailViewModel {
    
    private let service = HomeDetailService()
    private let routeFindService = RouteFindService()
    private var timer: Timer?
    var routeEndReason: RouteEndReason = .none
    
    let scheduleId: Int
    unowned let homeViewModel: HomeScheduleViewModel
    
    var detail: ScheduleDetail?
    
    private var baseDepartureDate: Date?
    
    private var acceptedDetourIds: Set<Int> = []
    private var rejectedDetourIds: Set<Int> = []
    
    var uiDetours: [RouteDetour] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    init(
            scheduleId: Int,
            homeViewModel: HomeScheduleViewModel
    ) {
        self.scheduleId = scheduleId
        self.homeViewModel = homeViewModel
    }
    
    func load() {
        Task { await loadAsync() }
    }
    
    private var lateSeedMinutes: Int?
    private var lateSeedCapturedAt: Date?

    var lateSeed: (minutes: Int, capturedAt: Date)? {
        guard let m = lateSeedMinutes, let t = lateSeedCapturedAt else { return nil }
        return (m, t)
    }

    @MainActor
    private func loadAsync() async {
        do {
            let fetched = try await service.fetchDetail(scheduleId: scheduleId)
            // fetched.travel 은 TravelStatus
            
            if fetched.travel.lateArrivalMinutes > 0 {
                if lateSeedMinutes == nil || lateSeedCapturedAt == nil {
                    lateSeedMinutes = fetched.travel.lateArrivalMinutes
                    lateSeedCapturedAt = Date()
                }
            } else {
                lateSeedMinutes = nil
                lateSeedCapturedAt = nil
            }

            if baseDepartureDate == nil {
                baseDepartureDate = fetched.travel.expectedDepartureDate
            }

            let newStatus = deriveDepartureStatus(
                travel: fetched.travel,
                baseDepartureDate: baseDepartureDate
            )

            
            let updatedTravel = TravelStatus(
                status: newStatus,
                expectedDepartureTimeText: fetched.travel.expectedDepartureTimeText,
                expectedArrivalTimeText: fetched.travel.expectedArrivalTimeText,
                expectedDepartureDate: fetched.travel.expectedDepartureDate,
                expectedArrivalDate: fetched.travel.expectedArrivalDate,
                lateArrivalMinutes: fetched.travel.lateArrivalMinutes,
                leftOrDelayMinutes: fetched.travel.leftOrDelayMinutes,
                isStarted: fetched.travel.isStarted
            )

            detail = ScheduleDetail(
                travel: updatedTravel,
                baseDepartureDate: baseDepartureDate!,
                linkedTodos: fetched.linkedTodos,
                detourRecommendations: fetched.detourRecommendations
            )

        } catch {
            print("❌ load error:", error)
        }
    }

    
    // MARK: - Live Update
    var now: Date = Date()

    func startLiveRefresh() {
        stopLiveRefresh()

        now = Date()

        timer = Timer.scheduledTimer(
            withTimeInterval: 60,
            repeats: true
        ) { [weak self] _ in
            guard let self else { return }
            self.now = Date()
            Task { await self.loadAsync() }
        }
    }

    func stopLiveRefresh() {
        timer?.invalidate()
        timer = nil
    }
    
    func endRouteManually(
        latitude: Double,
        longitude: Double
    ) {
        routeEndReason = .manual

        stopLiveRefresh()
        homeViewModel.arrivedScheduleIds.insert(scheduleId)
        homeViewModel.expandedScheduleId = nil

        Task {
            try? await routeFindService.endRoute(
                scheduleId: scheduleId,
                latitude: latitude,
                longitude: longitude
            )
        }
    }

    
    // MARK: - Route accept
    func acceptRoute(
        suggestionId: Int,
        baseScheduleId: Int,
        detour: RouteDetour
    ) {
        Task { @MainActor in
            do {
                try await service.acceptRoute(
                    suggestionId: suggestionId,
                    request: RouteAcceptRequestDTO(
                        baseScheduleId: baseScheduleId,
                        title: detour.title,
                        location: .init(
                            name: detour.location,
                            lat: detour.lat,
                            lng: detour.lng
                        ),
                        requiredMinutes: detour.detourMinutes
                    )
                )

                uiDetours.removeAll {
                    $0.suggestionId == suggestionId
                }

                // 서버 기준 linkedTodos 갱신
                await loadAsync()

            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }



    // MARK: - Route reject
    func rejectRoute(suggestionId: Int) {
        Task { @MainActor in
            do {
                try await service.rejectRoute(suggestionId: suggestionId)

                uiDetours.removeAll {
                    $0.suggestionId == suggestionId
                }

            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }



    deinit {
        stopLiveRefresh()
    }
}

enum RouteEndReason {
    case none
    case manual
    case auto
}

private extension ScheduleDetailViewModel {

    func deriveDepartureStatus(
        travel: TravelStatus,
        baseDepartureDate: Date?
    ) -> DepartureStatus {

        // 🔴 1. 도착 지각 (최우선)
        if travel.lateArrivalMinutes > 0 {
            return .late(delayMinutes: travel.lateArrivalMinutes)
        }

        // 🟠 2. 출발 지연 (출발 시간이 늦어졌는가)
        if travel.expectedDepartureDate < now {
            return .delayed(
                delayMinutes: abs(travel.leftOrDelayMinutes)
            )
        }

        // 🟢 3. 지금 출발
        if travel.leftOrDelayMinutes <= 20 {
            return .now(remainingMinutes: max(0, travel.leftOrDelayMinutes))
        }

        // 🔵 4. 출발 준비
        return .preparing(remainingMinutes: travel.leftOrDelayMinutes)
    }
}
