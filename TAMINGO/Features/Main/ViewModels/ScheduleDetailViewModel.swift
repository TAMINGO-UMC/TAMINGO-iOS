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
    
    @MainActor
    private func loadAsync() async {
        isLoading = true
        errorMessage = nil

        do {
            let newDetail = try await service.fetchDetail(scheduleId: scheduleId)

            if routeEndReason == .manual {
                isLoading = false
                return
            }

            if uiDetours.isEmpty {
                uiDetours = newDetail.detourRecommendations
            }

            detail = newDetail
          
        } catch {
            let message = error.localizedDescription
            errorMessage = message

            if message.contains("이미 도착") || message.contains("HOME-005") {
                homeViewModel.arrivedScheduleIds.insert(scheduleId)
                homeViewModel.expandedScheduleId = nil
            }
        }

        isLoading = false
    }

    
    // MARK: - Live Update
    func startLiveRefresh() {
        stopLiveRefresh()

        // 열리자마자 1회 갱신
        Task { await loadAsync() }

        timer = Timer.scheduledTimer(
            withTimeInterval: 60,
            repeats: true
        ) { [weak self] _ in
            guard let self else { return }
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

                if let idx = uiDetours.firstIndex(where: { $0.suggestionId == suggestionId }) {
                    uiDetours[idx].state = .accepted
                }
                
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
