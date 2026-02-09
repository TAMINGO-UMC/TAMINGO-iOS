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
    let accessToken: String

        init(accessToken: String) {
            self.accessToken = accessToken
        }
    
    // MARK: - State
    var timelineItems: [HomeTimelineItem] = []
    var expandedScheduleId: Int?
    
    var scheduleDetailVMs: [Int: ScheduleDetailViewModel] = [:]
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    var detailViewModels: [Int: ScheduleDetailViewModel] = [:]
    
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
                    guard response.isSuccess else {
                        self.errorMessage = response.message
                        print("❌ HomeSchedule 실패:", response.code, response.message)
                        self.timelineItems = []
                        return
                    }

                    let items = response.result?.items ?? []
                    self.timelineItems = items.compactMap { $0.toModel() }

                    print("✅ HomeSchedule 서버 연동 성공:", self.timelineItems.count)
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
        print("🔥 toggleDepartureCard called:", schedule.id)

        if expandedScheduleId == schedule.id {
            expandedScheduleId = nil
            print("⬆️ collapse")
        } else {
            expandedScheduleId = schedule.id
            print("⬇️ expand:", schedule.id)

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
        isLoading = true

        service.acceptSuggestion(
            suggestionId: gap.id,
            accessToken: accessToken
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false

                switch result {
                case .success:
                    print("✅ 틈새 일정 편성 성공:", gap.id)

                    // 1. UI 즉시 반영
                    self.timelineItems.removeAll {
                        if case .gap(let g) = $0 {
                            return g.id == gap.id
                        }
                        return false
                    }

                    // 2. 서버 기준 재동기화
                    self.loadToday(accessToken: self.accessToken)

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
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
        // "12:00", "12:00:00", "12:00:00.000" 다 대응
        let comps = timeString.split(separator: ":")
        guard comps.count >= 2 else { return nil }

        // "00.000" 같이 붙는 경우까지 대비해서 숫자만 추출
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

    func scheduleState(for schedule: ScheduleSummary) -> ScheduleCardState {

        guard let start = todayTime(schedule.startTime) else {
            print("⚠️ startTime parse fail:", schedule.startTime)
            return .past
        }

        let now = Date()
        let durationMinutes = max(schedule.duration, 1)
        let end = start.addingTimeInterval(TimeInterval(durationMinutes * 60))

        if now < start { return .upcoming }
        if now < end { return .now }
        return .past
    }
}
