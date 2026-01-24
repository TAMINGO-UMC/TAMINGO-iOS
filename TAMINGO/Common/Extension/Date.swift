//
//  File.swift
//  TAMINGO
//
//  Created by 김도연 on 1/17/26.
//

import Foundation

extension Date {
    
    // MARK: - 해당 날짜의 자정 (00:00:00)을 반환합니다.
    /// ```
    /// let today = Date()
    /// let startOfToday = today.startOfDay
    /// ```
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    // MARK: - 해당 날짜가 오늘인지 확인합니다.
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    // MARK: - 두 날짜가 같은 날인지 (년, 월, 일 기준) 확인합니다.
    /// ```
    /// if date1.isSameDay(as: date2) { ... }
    /// ```
    func isSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    // MARK: - 원하는 형식의 문자열로 날짜를 변환합니다.
    /// ```
    /// let dateString = Date().toString(format: "yyyy년 M월 d일")
    /// ```
    /// - Parameter format: "yyyy.MM.dd", "M월 d일" 등 원하는 포맷
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR") // 한국 시간 기준
        return formatter.string(from: self)
    }
    
    // MARK: 연, 월, 일 정수로부터 Date 객체를 생성합니다. (Static 함수)
    /// ```
    /// let specificDate = Date.from(year: 2025, month: 8, day: 7)
    /// ```
    static func from(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components)
    }
    
    // MARK: - Date 타입을 HH:mm으로 변환 합니다.
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

}

extension String {
    func toTimeDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
}
