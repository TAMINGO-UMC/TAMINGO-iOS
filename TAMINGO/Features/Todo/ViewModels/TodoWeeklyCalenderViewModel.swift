//
//  TodoWeeklyCalendarViewModel.swift
//  TAMINGO
//
//  Created by Claude on 2/9/26.
//  Todo 전용 주간 캘린더 뷰모델 (마커 지원)
//

import Foundation
import SwiftUI
import Observation

/// 캘린더 마커를 위한 구조체
struct TodoMarker: Hashable {
    let color: Color
    let category: String  // ✅ 카테고리 이름 추가
}

@Observable
class TodoWeeklyCalendarViewModel {
    private let calendar = Calendar.current
    
    var selectDate: Date = Date()
    var dateMarkers: [Date: [TodoMarker]] = [:]
    
    init() {
        self.selectDate = Date().startOfDay
    }
    
    // MARK: - 마커 관리
    func addMarker(for date: Date, color: Color, category: String) {
        let dayKey = date.startOfDay
        var markers = dateMarkers[dayKey] ?? []
        
        // ✅ 같은 카테고리가 이미 있으면 추가하지 않음 (중복 제거)
        if !markers.contains(where: { $0.category == category }) {
            markers.append(TodoMarker(color: color, category: category))
            dateMarkers[dayKey] = markers
        }
    }
    
    // ✅ 현재 표시 중인 범례용 카테고리 목록
    var visibleCategories: [(category: String, color: Color)] {
        let allMarkers = dateMarkers.values.flatMap { $0 }
        let uniqueCategories = Dictionary(grouping: allMarkers, by: { $0.category })
            .map { (category: $0.key, color: $0.value.first?.color ?? .gray) }
            .sorted { $0.category < $1.category }
        return uniqueCategories
    }
    
    func setMarkers(_ markers: [Date: [TodoMarker]]) {
        self.dateMarkers = markers
    }
    
    func clearAllMarkers() {
        dateMarkers.removeAll()
    }
    
    // MARK: - 주간 날짜 데이터
    func getThisWeekDateValues(baseDate: Date) -> [DateValue] {
        guard let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate)
        ) else {
            return []
        }
        
        return (0..<7).compactMap { offset in
            if let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) {
                let day = calendar.component(.day, from: date)
                // 주간 캘린더에서는 모든 날짜를 표시하므로 isCurrentMonth는 항상 true
                return DateValue(day: day, date: date, isCurrentMonth: true)
            }
            return nil
        }
    }
}
