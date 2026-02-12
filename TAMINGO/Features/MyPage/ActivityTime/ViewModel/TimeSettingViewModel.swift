//
//  TimeSettingViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import Foundation

//Mock Data
//enum ActivityTimeMock {
//
//    static let weekdayDefault = ActivityTime(
//        startTime: "08:00".toTimeDate()!,
//        endTime: "22:00".toTimeDate()!,
//        activeDays: [.mon, .tue, .wed, .thu, .fri]
//    )
//
//    static let weekendOnly = ActivityTime(
//        startTime: "10:00".toTimeDateOrFail(),
//        endTime: "18:00".toTimeDateOrFail(),
//        activeDays: [.sat, .sun]
//    )
//}
//

@Observable
final class TimeSettingViewModel{
    
    private let service: ActivityTimeServiceProtocol
    
    // MARK: - State
    var startTime: Date = Date()
    var endTime: Date = Date()
    var activeDays: Set<Weekday> = []
  
    // UI
    var didSelectStartTime = false
    var didSelectEndTime = false

    // 변경 비교용
    private var originalActivityTime: ActivityTime?

    // MARK: - Validation
    // 시간 유효성 검증
    var isTimeValid: Bool {
        endTime > startTime
    }
    
    // 변경 감지 - 버튼 활성화 여부 판단
    var hasChanges: Bool {
        guard let original = originalActivityTime else { return false }
        return startTime != original.startTime ||
               endTime != original.endTime ||
               activeDays != original.activeDays
    }
    
    // 저장 가능 여부
    var canSave: Bool {
            isTimeValid && hasChanges && !activeDays.isEmpty
        }
    
    // MARK: - 시간 계산

    private let dayDuration: TimeInterval = 24 * 60 * 60

    var activityDuration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }

    var startOffsetRatio: CGFloat {
        let seconds =
            Calendar.current.component(.hour, from: startTime) * 3600 +
            Calendar.current.component(.minute, from: startTime) * 60

        return CGFloat(seconds) / dayDuration
    }

    var activityProgress: CGFloat {
        guard activityDuration > 0 else { return 0 }
        return min(activityDuration / dayDuration, 1)
    }

    // MARK: - 시간 텍스트

    var timeDescription: String {
        guard isTimeValid else {
            return ""
        }

        let totalMinutes = Int(activityDuration / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        let durationText: String = {
            if minutes == 0 {
                return "\(hours)시간"
            } else {
                return "\(hours)시간 \(String(format: "%02d", minutes))분"
            }
        }()

        return "\(startTime.toString(format: "HH:mm")) ~ \(endTime.toString(format: "HH:mm")) (\(durationText))"
    }


    // MARK: - Init
    init(service: ActivityTimeServiceProtocol = ActivityTimeSettingService()) {
        self.service = service
    }
    
    // MARK: - 요일

    func isDayActive(_ day: Weekday) -> Bool {
        activeDays.contains(day)
    }

    func isWeekendActive() -> Bool {
        activeDays.contains(.sat) && activeDays.contains(.sun)
    }

    func toggleDay(_ day: Weekday, isOn: Bool) {
        if isOn {
            activeDays.insert(day)
        } else {
            activeDays.remove(day)
        }
    }

    func toggleWeekend(isOn: Bool) {
        if isOn {
            activeDays.formUnion([.sat, .sun])
        } else {
            activeDays.subtract([.sat, .sun])
        }
    }

    

    // MARK: - 도메인 변환
    func makeActivityTime() -> ActivityTime {
        ActivityTime(
            startTime: startTime,
            endTime: endTime,
            activeDays: activeDays
        )
    }
    
}

// 실행
extension TimeSettingViewModel {
    @MainActor
    func fetchActivityTime() async {
        do {
            let activityTime = try await service.fetchActivityTime()

            startTime = activityTime.startTime
            endTime = activityTime.endTime
            activeDays = activityTime.activeDays

            originalActivityTime = activityTime
        } catch {
            print("❌ fetch error:", error)
        }
    }
    
    @MainActor
    func save() async throws -> ActivityTime {
        let saved = try await service.saveActivityTime(
            makeActivityTime().toDTO()
        )

        startTime = saved.startTime
        endTime = saved.endTime
        activeDays = saved.activeDays
        originalActivityTime = saved

        return saved
    }


}
