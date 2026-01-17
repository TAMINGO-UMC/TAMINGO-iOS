//
//  DateValue.swift
//  TAMINGO
//
//  Created by 김도연 on 1/17/26.
//

import Foundation

// 달력 셀 하나에 해당하는 데이터 모델
struct DateValue: Identifiable, Equatable {
    
    // 날짜를 문자열로 포맷하여 항상 같은 날짜에는 같은 id가 부여되도록 함
    var id: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    let day: Int

    let date: Date
    
    let isCurrentMonth: Bool

    // 두 날짜가 같은 날인지 비교하는 Equatable 구현
    // 시, 분, 초는 무시하고 연·월·일만 비교
    // -day 값까지 비교해서 공백 셀(-1)을 구분
    static func == (lhs: DateValue, rhs: DateValue) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(lhs.date, inSameDayAs: rhs.date) && lhs.day == rhs.day
    }
}
