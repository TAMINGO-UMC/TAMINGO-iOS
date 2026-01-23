//
//  CalendarViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 1/17/26.
//

import Foundation
import SwiftUI
import Observation

/// 캘린더 마커를 위한 구조체. 마커의 색상을 정의
struct Marker: Hashable {
    let color: Color
}

@Observable
class CalendarViewModel {
    // Observation에서는 프로퍼티가 ObservationIgnored가 아닌 이상 자동으로 추적됩니다.
    private let calendar = Calendar.current

    var selectDate: Date = Date()
    var previousMonth: Int = 0
    
    var dateMarkers: [Date: [Marker]] = [:]
    
    var displayedMonthDate: Date = Date()
        
    init() {
        let now = Date().startOfDay
        self.selectDate = now
        self.previousMonth = calendar.component(.month, from: now)
        let components = calendar.dateComponents([.year, .month], from: now)
        self.displayedMonthDate = calendar.date(from: components) ?? now
    }
    
    // MARK: - 마커 관리
    
    func addMarker(for date: Date, color: Color) {
        let dayKey = date.startOfDay
        
        var markers = dateMarkers[dayKey] ?? []
        let newMarker = Marker(color: color)
        
        if markers.count >= 3 {
            markers.removeFirst()
        }
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
}
