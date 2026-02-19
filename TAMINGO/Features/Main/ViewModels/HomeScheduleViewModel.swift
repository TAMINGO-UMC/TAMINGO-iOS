//
//  HomeScheduleViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/23/26.
//

import SwiftUI
import Observation
internal import _LocationEssentials

@Observable
final class HomeScheduleViewModel {

    // MARK: - Dependencies
    private let service = HomeService()

    // MARK: - State
    var timelineItems: [HomeTimelineItem] = []
    var expandedScheduleId: Int?
    
    var detailViewModels: [Int: ScheduleDetailViewModel] = [:]

    var nextScheduleId: Int?

    var isLoading: Bool = false
    var errorMessage: String?
    
    var arrivedScheduleIds: Set<Int> = []
    
    private let locationService = LocationService()
    private let locationManager = LocationManager.shared


    // MARK: - API
    func loadToday() {
        Task { await loadTodayAsync() }
    }

    @MainActor
    private func loadTodayAsync() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchTodayTimeline()

            guard response.isSuccess else {
                errorMessage = response.message
                timelineItems = []
                isLoading = false
                return
            }

            let items = response.result?.items ?? []
            timelineItems = items.compactMap { $0.toModel() }
            
            expandedScheduleId = nil

            updateNextSchedule()

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - 가장 첫 번째 남은 일정 찾기
    private func updateNextSchedule() {

        let now = Date()

        for item in timelineItems {
            if case let .schedule(schedule) = item {
                if let start = todayTime(schedule.startTime), start >= now {
                    nextScheduleId = schedule.id
                    return
                }
            }
        }

        nextScheduleId = nil
    }

    // MARK: - 상태 계산
    func scheduleState(for schedule: ScheduleSummary) -> ScheduleCardState {

        
        // 가장 첫 번째 남은 일정이면 .now
        if schedule.id == nextScheduleId {
            return .now
        }

        // 이미 지난 일정이면 .past
        guard let start = todayTime(schedule.startTime) else {
            return .past
        }

        if start < Date() {
            return .past
        }

        // 나머지는 upcoming
        return .upcoming
    }

    // MARK: - UI Interaction
    func toggleDepartureCard(for schedule: ScheduleSummary) {

        // 이미 도착 처리된 일정이면 무조건 무시
        if arrivedScheduleIds.contains(schedule.id) {
            print("🚫 arrived schedule - toggle blocked:", schedule.id)
            return
        }

        print("🔥 toggle called for:", schedule.id)

        if expandedScheduleId == schedule.id {
            expandedScheduleId = nil
            return
        }

        expandedScheduleId = schedule.id

        let vm = detailViewModel(for: schedule.id)
        if vm.detail == nil {
            print("🔥 loading detail...")
            vm.load()
        }
    }

    func acceptGap(_ gap: GapTime) {
        Task { await acceptGapAsync(gap) }
    }

    @MainActor
    private func acceptGapAsync(_ gap: GapTime) async {
        isLoading = true

        do {
            try await service.acceptSuggestion(id: gap.id)
            await loadTodayAsync()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func rejectGap(_ gap: GapTime) {
        Task { await rejectGapAsync(gap) }
    }

    @MainActor
    private func rejectGapAsync(_ gap: GapTime) async {
        isLoading = true

        do {
            try await service.rejectSuggestion(id: gap.id)
            await loadTodayAsync()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Detail VM cache
    func detailViewModel(for scheduleId: Int) -> ScheduleDetailViewModel {

        if let cached = detailViewModels[scheduleId] {
            return cached
        }

        let vm = ScheduleDetailViewModel(
            scheduleId: scheduleId,
            homeViewModel: self 
        )
        detailViewModels[scheduleId] = vm
        return vm
    }
    
    func preloadDetailsIfNeeded() {
        for item in timelineItems {
            guard case let .schedule(schedule) = item else { continue }

            if detailViewModels[schedule.id] == nil {
                let vm = ScheduleDetailViewModel(
                    scheduleId: schedule.id,
                    homeViewModel: self
                )
                detailViewModels[schedule.id] = vm
                vm.load()
            }
        }
    }

    func correctDepartureIfNeeded() {

        guard let nextId = nextScheduleId else { return }

        Task {
            do {
                let coord = try await locationManager.currentLocation()

                _ = try await locationService.silentGPS(
                    scheduleId: nextId,
                    latitude: coord.latitude,
                    longitude: coord.longitude
                )

                await loadTodayAsync()

            } catch {
                print("❌ silentGPS error:", error)
            }
        }
    }

}


extension ScheduleSummary {

    var startDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: startTime)
    }
}


extension HomeScheduleViewModel {

    private func todayTime(_ timeString: String) -> Date? {

        let comps = timeString.split(separator: ":")
        guard comps.count >= 2 else { return nil }

        let hour = Int(comps[0].filter(\.isNumber)) ?? -1
        let minute = Int(comps[1].filter(\.isNumber)) ?? -1
        guard (0...23).contains(hour), (0...59).contains(minute) else { return nil }

        var calendar = Calendar.current
        calendar.timeZone = .current

        return calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: Date()
        )
    }
}
