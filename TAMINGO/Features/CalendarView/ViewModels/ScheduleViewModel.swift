//
//  ScheduleViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 1/18/26.
//

import SwiftUI
import Observation

@Observable
class ScheduleViewModel {
    
    // 전체 일정 리스트 (서버에서 받아온 원본)
    var allSchedules: [ScheduleItem] = []
    
    init() {
        self.allSchedules = generateDummyData()
    }
    
    // MARK: - 로직: 날짜별 필터링
    
    /// 달력에서 선택한 날짜(selectedDate)에 해당하는 일정만 반환
    func getSchedules(for date: Date) -> [ScheduleItem] {
        return allSchedules.filter { schedule in
            // schedule.startDateTime과 선택된 date가 '같은 날'인지 확인
            Calendar.current.isDate(schedule.startDateTime, inSameDayAs: date)
        }
    }
    
    // MARK: - 더미 데이터 생성 (API 연동 전 테스트용)
    private func generateDummyData() -> [ScheduleItem] {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        // 오늘 날짜 기준으로 더미 데이터 생성 (테스트용)
        let date1 = calendar.date(bySettingHour: 9, minute: 40, second: 0, of: yesterday)!
        let date2 = calendar.date(bySettingHour: 10, minute: 40, second: 0, of: today)!
        
        let date3 = calendar.date(bySettingHour: 14, minute: 00, second: 0, of: today)!
        let date4 = calendar.date(bySettingHour: 15, minute: 30, second: 0, of: today)!
        
        return [
            ScheduleItem(id: 1, title: "팀플 미팅", place: "S관 301", category: .school, startDateTime: date1, endDateTime: date2, memo: "발표 자료 준비"),
            ScheduleItem(id: 2, title: "전공 강의", place: "공학관", category: .partTimeJob, startDateTime: date3, endDateTime: date4, memo: nil),
            ScheduleItem(id: 3, title: "동아리 모임", place: "학생회관", category: .club, startDateTime: date2, endDateTime: date3, memo: nil)
        ]
    }
}
