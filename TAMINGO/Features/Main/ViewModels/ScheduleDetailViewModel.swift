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
    let scheduleId: Int
    
    var detail: ScheduleDetail?
    var isLoading: Bool = false
    var errorMessage: String?
    
    init(scheduleId: Int) {
        self.scheduleId = scheduleId
    }
    
    func load() {
        Task { await loadAsync() }
    }
    
    @MainActor
    private func loadAsync() async {
        print("detail loadAsync start:", scheduleId)
        
        isLoading = true
        errorMessage = nil
        
        do {
            detail = try await service.fetchDetail(scheduleId: scheduleId)
            print("detail success:", detail)
        } catch {
            print("detail error:", error)
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Route accept
    func acceptRoute(suggestionId: Int, baseScheduleId: Int, detour: RouteDetour) {
        let request = RouteAcceptRequestDTO(
            baseScheduleId: baseScheduleId,
            title: detour.title,
            location: .init(name: detour.location, lat: detour.lat, lng: detour.lng),
            requiredMinutes: Int(detour.detourMinutes) ?? 0
        )
        
        Task {
            do {
                print("🟢 [ACCEPT] suggestionId:", detour.suggestionId, "baseScheduleId:", baseScheduleId)
                try await service.acceptRoute(suggestionId: detour.suggestionId, request: request)
                print("🟢 [ACCEPT] success → reload detail")
                await loadAsync()
            } catch {
                print("🔴 [ACCEPT ERROR]:", error)
                errorMessage = error.localizedDescription
            }
        }
    }
    
    
    // MARK: - Route reject
    func rejectRoute(suggestionId: Int) {
        Task {
            do {
                print("🟡 [REJECT] suggestionId:", suggestionId)
                try await service.rejectRoute(suggestionId: suggestionId)
                print("🟡 [REJECT] success → reload detail")
                await loadAsync()
            } catch {
                print("🔴 [REJECT ERROR]:", error)
                errorMessage = error.localizedDescription
            }
        }
    }
}
