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
                print("🚫 auto-arrival ignored (manual end)")
                isLoading = false
                return
            }
            
            detail = newDetail
          
        } catch {
            let message = error.localizedDescription
            errorMessage = message

            // 이미 도착 처리된 일정
            if message.contains("이미 도착") || message.contains("HOME-005") {
                print("✅ arrived confirmed from server:", scheduleId)

                homeViewModel.arrivedScheduleIds.insert(scheduleId)

                // UI 즉시 반영
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
        let request = RouteAcceptRequestDTO(
            baseScheduleId: baseScheduleId,
            title: detour.title,
            location: .init(
                name: detour.location,
                lat: detour.lat,
                lng: detour.lng
            ),
            requiredMinutes: detour.detourMinutes
        )

        Task { @MainActor in
            do {
                try await service.acceptRoute(
                    suggestionId: suggestionId,
                    request: request
                )
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
                await loadAsync()
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
