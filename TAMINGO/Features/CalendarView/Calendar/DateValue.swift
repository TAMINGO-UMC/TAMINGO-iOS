//
//  DateValue.swift
//  TAMINGO
//
//  Created by 김도연 on 1/17/26.
//

import Foundation

// 달력 셀 하나에 해당하는 데이터 모델
// DateValue.swift 수정 제안
struct DateValue: Identifiable, Equatable {
    
    // 포매터는 그대로 유지
    private static let idFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let id: String
    let day: Int
    let date: Date
    let isCurrentMonth: Bool
    
    // 생성자(init) 추가
    init(day: Int, date: Date, isCurrentMonth: Bool) {
        self.day = day
        self.date = date
        self.isCurrentMonth = isCurrentMonth
        self.id = Self.idFormatter.string(from: date)
    }
    
    static func == (lhs: DateValue, rhs: DateValue) -> Bool {
        // id가 이미 날짜 정보를 담고 있으므로 id끼리 비교해도 충분히 정확하고 훨씬 빠름
        return lhs.id == rhs.id
    }
}
