//
//  CalendarViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 1/17/26.
//

import Foundation
import SwiftUI
import Observation
import Moya

/// 캘린더 마커를 위한 구조체.
/// Identifiable을 채택하여 같은 색상이라도 고유하게 식별되도록 수정
struct Marker: Hashable, Identifiable {
    let id = UUID() // 고유 ID 자동 생성
    let color: Color
}

@Observable
class CalendarViewModel {
    private let provider = MoyaProvider<ScheduleTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .successResponseBody))])
    
    private let calendar = Calendar.current
    
    var selectDate: Date = Date()
    var previousMonth: Int = 0
    
    var categoryMap: [String: Color] = [:]
    var dateMarkers: [Date: [Marker]] = [:]
    var allSchedules: [ScheduleListDTO] = []
    var selectedDateSchedules: [ScheduleListDTO] = []
    var categories: [(key: String, value: Color)] = []
    
    var displayedMonthDate: Date = Date()
    
    init() {
        let now = Date().startOfDay
        self.selectDate = now
        self.previousMonth = calendar.component(.month, from: now)
        let components = calendar.dateComponents([.year, .month], from: now)
        self.displayedMonthDate = calendar.date(from: components) ?? now
    }
    
    func fetchData() async {
        // 선택된 달을 "yyyy-MM"로 변환
        let dateString = displayedMonthDate.toString(format: "yyyy-MM")
        
        do {
            // 월별 데이터 요청
            let response: BaseResponse<MonthlyCalendarResultDTO> = try await provider.request(.getMonthly(date: dateString))
            
            if let result = response.result {
                // 카테고리 정보 업데이트
                self.updateCategoryMap(with: result.categories)
                
                // 일정 데이터 저장 및 마커 생성
                self.allSchedules = result.schedules
                self.setMarkers(from: result.schedules)
                
                // 현재 날짜의 일정 필터링
                self.filterSchedules(for: selectDate)
            }
            
        } catch {
            print("데이터 로딩 중 에러 발생: \(error)")
        }
    }
    
    private func updateCategoryMap(with categories: [CategoryDTO]) {
        var newMap: [String: Color] = [:]
        for cat in categories {
            newMap[cat.name] = Color(hex: cat.colorCode)
        }
        self.categoryMap = newMap
        self.categories = newMap.sorted { $0.key < $1.key }
    }
    
    // MARK: - 마커 관리
    func setMarkers(from schedules: [ScheduleListDTO]) {
        clearAllMarkers()
        
        for schedule in schedules {
            // 매핑된 색상이 없으면 기본색(gray) 사용
            let color = categoryMap[schedule.category] ?? .gray
            
            if let date = schedule.startTime.toDate() {
                addMarker(for: date, color: color)
            }
        }
    }
    
    func addMarker(for date: Date, color: Color) {
        let dayKey = date.startOfDay
        
        var markers = dateMarkers[dayKey] ?? []
        let newMarker = Marker(color: color)
        
        markers.append(newMarker)
        dateMarkers[dayKey] = markers
    }
    
    func removeMarker(for date: Date, color: Color) {
        let dayKey = date.startOfDay
        
        if let oldMarkers = dateMarkers[dayKey] {
            let newMarkers = oldMarkers.filter { $0.color != color }
            if newMarkers.isEmpty {
                dateMarkers.removeValue(forKey: dayKey)
            } else {
                dateMarkers[dayKey] = newMarkers
            }
        }
    }
    
    func clearAllMarkers() {
        dateMarkers.removeAll()
    }
    
    // MARK: - 캘린더 UI 및 날짜 계산 로직
    
    private func moveMonth(by value: Int, onDateSelected: ((Date) -> Void)?) {
        if let newMonthDate = calendar.date(byAdding: .month, value: value, to: displayedMonthDate) {
            displayedMonthDate = newMonthDate.startOfDay
        }
        
        if let newSelectedDate = calendar.date(byAdding: .month, value: value, to: selectDate) {
            updateSelectedDate(newSelectedDate, onDateSelected: onDateSelected)
        }
    }
    
    func moveCalendar(by value: Int, onDateSelected: ((Date) -> Void)?) {
        moveMonth(by: value, onDateSelected: onDateSelected)
    }
    
    func updateSelectedDate(_ date: Date, onDateSelected: ((Date) -> Void)?) {
        let startOfDay = date.startOfDay
        
        if selectDate == startOfDay { return }
        
        selectDate = startOfDay
        
        let newMonth = calendar.component(.month, from: startOfDay)
        if newMonth != previousMonth {
            previousMonth = newMonth
        }
        filterSchedules(for: startOfDay)
        
        onDateSelected?(startOfDay)
        
        var selectedComponents = calendar.dateComponents([.year, .month], from: startOfDay)
        selectedComponents.day = 1
        let displayedComponents = calendar.dateComponents([.year, .month], from: displayedMonthDate)
        if selectedComponents.year != displayedComponents.year || selectedComponents.month != displayedComponents.month {
            if let newDisplayedDate = calendar.date(from: selectedComponents) {
                displayedMonthDate = newDisplayedDate
            }
        }
    }
    
    // MARK: - 선택된 날짜의 일정 리스트 필터링
    func filterSchedules(for date: Date) {
        // allSchedules(한달치)에서 해당 날짜와 같은 것만 골라냄
        self.selectedDateSchedules = self.allSchedules.filter { schedule in
            guard let scheduleDate = schedule.startTime.toDate() else { return false }
            return calendar.isDate(scheduleDate, inSameDayAs: date)
        }
    }
    
    // MARK: - 달력 데이터 생성
    
    func extractDate() -> [DateValue] {
        var days: [DateValue] = []
        
        let firstDay = firstDayOfMonth()
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let daysInMonth = numberOfDays(in: displayedMonthDate)
        
        let leadingDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        if leadingDays > 0 {
            guard let lastDayOfPreviousMonth = calendar.date(byAdding: .day, value: -1, to: firstDay) else {
                return []
            }
            
            for i in (0..<leadingDays).reversed() {
                if let date = calendar.date(byAdding: .day, value: -i, to: lastDayOfPreviousMonth) {
                    let day = calendar.component(.day, from: date)
                    days.append(DateValue(day: day, date: date, isCurrentMonth: false))
                }
            }
        }
        
        var lastDayOfMonth: Date?
        for day in 1...daysInMonth {
            if let date = calendar.date(bySetting: .day, value: day, of: firstDay) {
                days.append(DateValue(day: day, date: date, isCurrentMonth: true))
                lastDayOfMonth = date
            }
        }
        
        if let lastDay = lastDayOfMonth {
            let lastWeekday = calendar.component(.weekday, from: lastDay)
            let trailingDays = 7 - ((lastWeekday - calendar.firstWeekday + 7) % 7) - 1
            
            if trailingDays > 0 {
                guard let firstDayOfNextMonth = calendar.date(byAdding: .day, value: 1, to: lastDay) else {
                    return days
                }
                
                for i in 0..<trailingDays {
                    if let date = calendar.date(byAdding: .day, value: i, to: firstDayOfNextMonth) {
                        let day = calendar.component(.day, from: date)
                        days.append(DateValue(day: day, date: date, isCurrentMonth: false))
                    }
                }
            }
        }
        
        return days
    }
    
    func getThisWeekDateValues() -> [DateValue] {
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectDate)) else {
            return []
        }
        
        return (0..<7).compactMap { offset in
            if let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) {
                let day = calendar.component(.day, from: date)
                let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonthDate, toGranularity: .month)
                return DateValue(day: day, date: date, isCurrentMonth: isCurrentMonth)
            }
            return nil
        }
    }
    
    func getMarkersForThisWeek() -> [[Marker]] {
        return getThisWeekDateValues().map { dateValue in
            dateMarkers[dateValue.date.startOfDay] ?? []
        }
    }
    
    private func firstDayOfMonth() -> Date {
        let components = calendar.dateComponents([.year, .month], from: displayedMonthDate)
        return calendar.date(from: components) ?? Date()
    }
    
    private func numberOfDays(in month: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: month)?.count ?? 0
    }
    
    /// 선택된 날짜의 '월' (숫자)
    var selectedMonth: Int {
        calendar.component(.month, from: selectDate)
    }
    
    /// 선택된 날짜의 '일' (숫자)
    var selectedDay: Int {
        calendar.component(.day, from: selectDate)
    }
    
    /// 선택된 날짜의 요일 (예: "월", "화", "수")
    var selectedWeekday: String {
        let weekdayIndex = calendar.component(.weekday, from: selectDate)
        // calendar.component(.weekday, ...)는 일요일(1) ~ 토요일(7)을 반환합니다.
        // 배열 인덱스(0~6)로 맞추기 위해 1을 뺍니다.
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        
        // 안전하게 인덱스 접근
        if weekdayIndex >= 1 && weekdayIndex <= 7 {
            return weekdays[weekdayIndex - 1]
        }
        return ""
    }
}
