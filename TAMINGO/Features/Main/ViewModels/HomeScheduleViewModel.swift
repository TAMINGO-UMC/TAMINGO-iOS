//
//  HomeScheduleViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/23/26.
//

import SwiftUI
import Observation

@Observable
final class HomeScheduleViewModel {
    
    // MARK: - Dependencies
    private let service = HomeService()
    
    // MARK: - State
    var timelineItems: [HomeTimelineItem] = []
    var expandedScheduleId: Int?
    
    var scheduleDetailVMs: [Int: ScheduleDetailViewModel] = [:]
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    var detailViewModels: [Int: ScheduleDetailViewModel] = [:]
    let accessToken: String = ""
    
    // MARK: - API 연동
    
    func loadToday(accessToken: String) {
        isLoading = true
        errorMessage = nil
        
        service.fetchTodayTimeline(accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                
                switch result {
                    
                case .success(let response):
                    // DTO → Model 변환
                    self.timelineItems = response.result.items
                        .compactMap { $0.toModel() }
                    
                    print("✅ HomeSchedule 서버 연동 성공")
                    print("📦 timelineItems:", self.timelineItems.count)
                    dump(self.timelineItems)
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ HomeSchedule 서버 연동 실패:", error)
                }
            }
        }
    }
    
    // MARK: - UI Interaction (View가 쓰는 것들)
    func toggleDepartureCard(
        for schedule: ScheduleSummary,
        accessToken: String
    ) {
        if expandedScheduleId == schedule.id {
            expandedScheduleId = nil
        } else {
            expandedScheduleId = schedule.id

            if scheduleDetailVMs[schedule.id] == nil {
                let vm = ScheduleDetailViewModel(
                    scheduleId: schedule.id,
                    accessToken: accessToken
                )
                scheduleDetailVMs[schedule.id] = vm
                vm.load()
            }
        }
    }
    
    // MARK: - GAP (틈새 시간)
    func acceptGap(_ gap: GapTime) {
        guard let index = timelineItems.firstIndex(where: {
            if case .gap(let g) = $0 { return g.id == gap.id }
            return false
        }) else { return }
        
        let newSchedule = ScheduleSummary(
            id: Int.random(in: 1000...9999),
            title: gap.title,
            startTime: gap.gapStartTime,
            placeName: gap.location,
            leftMinute: 0,
            duration: 0,
            isNextSchedule: false
        )
        
        timelineItems[index] = .schedule(newSchedule)
    }
    
    func rejectGap(_ gap: GapTime) {
        timelineItems.removeAll {
            if case .gap(let g) = $0 { return g.id == gap.id }
            return false
        }
    }
    
    // MARK: -  detail-ViewModel
    func detailViewModel(for scheduleId: Int) -> ScheduleDetailViewModel {
        if let vm = detailViewModels[scheduleId] {
            return vm
        }

        let vm = ScheduleDetailViewModel(
            scheduleId: scheduleId,
            accessToken: accessToken
        )
        vm.load()
        detailViewModels[scheduleId] = vm
        return vm
    }

}
