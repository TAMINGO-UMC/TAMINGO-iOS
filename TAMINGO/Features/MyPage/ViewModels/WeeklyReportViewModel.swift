//
//  WeeklyReportViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//

import Foundation

@Observable
final class WeeklyReportViewModel {
    // 조회 기간 설정 리스트
    var isPeriodListVisible: Bool = false
    // 오늘 날짜
    private let baseDate: Date

    // 선택된 조회 기간
    var selectedPeriod: PeriodOption = .thisWeek

    // SelectList에 뿌릴 옵션
    let periodOptions: [PeriodOption] = [
        .thisWeek,
        .lastWeek,
        .thisMonth
    ]
    
    // 선택 기간 표시
    var selectedPeriodText: String {
        let range = selectedRange
        return "\(selectedPeriod.displayTitle) (\(range.formatted))"
    }

    init(baseDate: Date = Date()) {
        self.baseDate = baseDate
    }
    
    // 기간 반환
    private var selectedRange: PeriodRange {
        range(for: selectedPeriod)
    }

    // 시작일 텍스트 (UI 전용)
    var startDateText: String {
        selectedRange.start.toString(format: "yyyy.MM.dd")
    }

    // 종료일 텍스트 (UI 전용)
    var endDateText: String {
        selectedRange.end.toString(format: "yyyy.MM.dd")
    }

    func title(for option: PeriodOption) -> String {
        let range = range(for: option)
        return "\(option.displayTitle) (\(range.formatted))"
    }
}

extension WeeklyReportViewModel {

    func range(for option: PeriodOption) -> PeriodRange {
        let calendar = Calendar.current

        switch option {

        case .thisWeek:
            let start = calendar
                .date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate))!
                .startOfDay

            let end = calendar
                .date(byAdding: .day, value: 6, to: start)!
                .startOfDay

            return PeriodRange(start: start, end: end)

        case .lastWeek:
            let thisWeekStart = calendar
                .date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate))!
                .startOfDay

            let start = calendar
                .date(byAdding: .day, value: -7, to: thisWeekStart)!
                .startOfDay

            let end = calendar
                .date(byAdding: .day, value: 6, to: start)!
                .startOfDay

            return PeriodRange(start: start, end: end)

        case .thisMonth:
            let start = calendar
                .date(from: calendar.dateComponents([.year, .month], from: baseDate))!
                .startOfDay

            let end = calendar
                .date(byAdding: DateComponents(month: 1, day: -1), to: start)!
                .startOfDay

            return PeriodRange(start: start, end: end)
        }
    }

}

