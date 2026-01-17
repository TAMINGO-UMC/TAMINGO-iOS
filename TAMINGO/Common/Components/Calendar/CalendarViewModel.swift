//
//  CalendarViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 1/17/26.
//

import Foundation
import SwiftUI
import Combine

/// 캘린더 마커를 위한 구조체. 마커의 색상을 정의
struct Marker: Hashable {
    let color: Color
}

final class CalendarViewModel: ObservableObject {
    private let calendar = Calendar.current  //Calendar.current를 반복적으로 호출하는 것을 방지하기 위해 프로퍼티로 선언
    
    @Published var selectDate: Date = Date()
    @Published var previousMonth: Int = Calendar.current.component(.month, from: Date())
    
    /// 각 날짜에 대한 마커 정보를 저장하는 딕셔너리
    /// 키는 `Date` (년, 월, 일만 고려), 값은 `Marker` 배열
    /// 한 날짜에 최대 3개의 마커를 가질 수 있음
    @Published var dateMarkers: [Date: [Marker]] = [:]
    
    /// 월 기준 날짜 (1일)
    @Published var displayedMonthDate: Date = {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components) ?? Date()
    }()
        
    init() {
        let now = Date().startOfDay
        self.selectDate = now
        let components = calendar.dateComponents([.year, .month], from: now)
        self.displayedMonthDate = calendar.date(from: components) ?? now
    }
    
    
    // MARK: - 마커 관리
    
    /// 특정 날짜에 마커를 추가
    /// - Parameters:
    ///   - date: 마커를 추가할 날짜. 시간 정보는 무시하고 년, 월, 일만 사용됩니다.
    ///   - color: 마커의 색상.
    ///
    /// 이 함수는 주어진 날짜에 새로운 마커를 추가
    /// 한 날짜에 최대 3개의 마커만 추가할 수 있으며, 이미 3개의 마커가 있는 경우 가장 오래된 마커가 제거되고 새로운 마커가 추가됨
    func addMarker(for date: Date, color: Color) {
        let dayKey = date.startOfDay
        
        var markers = dateMarkers[dayKey] ?? []
        let newMarker = Marker(color: color)
        
        if markers.count >= 3 {
            // 3개 이상이면 가장 오래된(첫 번째) 마커를 제거하고 새 마커 추가
            markers.removeFirst()
        }
        markers.append(newMarker)
        dateMarkers[dayKey] = markers
        print("마커 정보 \(dateMarkers)")
    }
    
    /// 특정 날짜의 특정 색상 마커를 제거
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
    
    /// 모든 마커를 제거합니다. (월 이동 시 호출)
    func clearAllMarkers() {
        dateMarkers.removeAll()
    }
    
    // MARK: - 캘린더 UI 및 날짜 계산 로직
    /// 월 이동
    private func moveMonth(by value: Int, onDateSelected: ((Date) -> Void)?) {
            if let newMonthDate = calendar.date(byAdding: .month, value: value, to: displayedMonthDate) {
                displayedMonthDate = newMonthDate.startOfDay
            }
            
            if let newSelectedDate = calendar.date(byAdding: .month, value: value, to: selectDate) {
                updateSelectedDate(newSelectedDate, onDateSelected: onDateSelected)
            }
        }
    
    /// 캘린더 모드에 따라 이동
    func moveCalendar(by value: Int, onDateSelected: ((Date) -> Void)?) {
        moveMonth(by: value, onDateSelected: onDateSelected)
    }
    
    //// 날짜 선택 및 월 동기화
    func updateSelectedDate(_ date: Date, onDateSelected: ((Date) -> Void)?) {
        let startOfDay = date.startOfDay
        
        if selectDate == startOfDay { return }
        
        selectDate = startOfDay
        
        let newMonth = calendar.component(.month, from: startOfDay)
        if newMonth != previousMonth {
            previousMonth = newMonth
        }
        
        // 날짜별 일정 호출
        onDateSelected?(startOfDay)
        
        // displayedMonthDate 동기화
        var selectedComponents = calendar.dateComponents([.year, .month], from: startOfDay)
        selectedComponents.day = 1
        let displayedComponents = calendar.dateComponents([.year, .month], from: displayedMonthDate)
        if selectedComponents.year != displayedComponents.year || selectedComponents.month != displayedComponents.month {
            if let newDisplayedDate = calendar.date(from: selectedComponents) {
                displayedMonthDate = newDisplayedDate
            }
        }
    }

    // MARK: - 달력 데이터 생성 (리팩토링된 핵심 로직)
    /// 월간 캘린더 그리드를 구성하는 DateValue 배열을 생성합니다.
    /// 이전/현재/다음 달의 날짜를 모두 포함하여 항상 일정한 개수의 배열을 반환합니다.
    func extractDate() -> [DateValue] {
        var days: [DateValue] = []
        
        // 1. 현재 월의 정보 계산
        let firstDay = firstDayOfMonth()
        let firstWeekday = calendar.component(.weekday, from: firstDay) // 1(일) ~ 7(토)
        let daysInMonth = numberOfDays(in: displayedMonthDate)
        
        // 2. 이전 달 날짜 추가 (앞쪽 공백 채우기)
        let leadingDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        if leadingDays > 0 {
            // 이전 달의 마지막 날을 계산합니다.
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
        
        // 3. 현재 달 날짜 추가
            var lastDayOfMonth: Date?
            for day in 1...daysInMonth {
                if let date = calendar.date(bySetting: .day, value: day, of: firstDay) {
                    days.append(DateValue(day: day, date: date, isCurrentMonth: true))
                    lastDayOfMonth = date
                }
            }
        
        // 4. 마지막 주 토요일까지 채우기 (필요한 만큼만)
            if let lastDay = lastDayOfMonth {
                let lastWeekday = calendar.component(.weekday, from: lastDay) // 1~7
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
    
    // 주 기준 날짜 배열 생성
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

    // 주간 모드에서 주 전체 날짜의 마커 반환
    func getMarkersForThisWeek() -> [[Marker]] {
        return getThisWeekDateValues().map { dateValue in
            dateMarkers[dateValue.date.startOfDay] ?? []
        }
    }

    /// 현재 표시중인 월의 첫째 날 `Date`를 반환합니다.
    private func firstDayOfMonth() -> Date {
        let components = calendar.dateComponents([.year, .month], from: displayedMonthDate)
        return calendar.date(from: components) ?? Date()
    }
    
    /// 특정 월에 며칠이 있는지 반환합니다.
    private func numberOfDays(in month: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: month)?.count ?? 0
    }
    
}
