//
//  WeeklyReportViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//

import Foundation

@Observable
final class WeeklyReportViewModel {
    
    private let service: WeeklyReportServiceProtocol
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    var report: WeeklyReportDetail?
    
    // 조회 기간 설정 리스트
    var isPeriodListVisible: Bool = false
    // 오늘 날짜
    private let baseDate: Date

    // 선택된 조회 기간
    var selectedPeriod: PeriodOption = .lastWeek

    // SelectList에 뿌릴 옵션
    let periodOptions: [PeriodOption] = [
        .lastWeek,
        .thisMonth
    ]
    
    // 선택 기간 표시
    var selectedPeriodText: String {
        switch selectedPeriod {
        case .lastWeek:
            return "\(selectedPeriod.displayTitle) (\(selectedRange.formatted))"
            
        case .thisMonth:
            let month = Calendar.current.component(.month, from: baseDate)
            return "\(selectedPeriod.displayTitle) (\(month)월)"
        }
    }

    init(
        service: WeeklyReportServiceProtocol = WeeklyReportService(),
        baseDate: Date = Date()
    ) {
        self.service = service
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
    
    var month: Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: baseDate)
        return month
    }

    func title(for option: PeriodOption) -> String {
        switch option {
        case .lastWeek:
            return "\(option.displayTitle) (\(range(for: option).formatted))"
        case .thisMonth:
            return "\(option.displayTitle) (\(month)월)"
        }
    }
    // 요일별 활동
    var weeklyMetrics: [WeeklyMetric] {

        let report = self.report

        let onTimeValue = report?.onTimeRate.map { "\($0)%" } ?? "-%"
        let onTimeSub = report?.onTimeDiff.map {
            $0 == 0 ? "변동 없음" :
            $0 > 0 ? "+\($0)% 상승" :
            "\($0)% 감소"
        } ?? "-"

        let taskValue: String = {
            guard let done = report?.taskDoneCount,
                  let total = report?.taskTotalCount else {
                return "-/-개"
            }
            return "\(done)/\(total)개"
        }()

        let productivityValue = report?.productivityScore.map { "\($0)점" } ?? "-점"
        let productivitySub = report?.grade?.title ?? "-"

        return [
            WeeklyMetric(
                title: "정시 도착률",
                value: onTimeValue,
                subValue: onTimeSub,
                iconName: "MyPage_icon_report01",
                textColor: .subBlue2,
                backgroundColor: .subBlue1
            ),
            WeeklyMetric(
                title: "할 일 완료율",
                value: taskValue,
                subValue: taskValue,
                iconName: "MyPage_icon_report02",
                textColor: .subPP2,
                backgroundColor: .subPP1
            ),
            WeeklyMetric(
                title: "생산성 점수",
                value: productivityValue,
                subValue: productivitySub,
                iconName: "MyPage_icon_report03",
                textColor: .subPink2,
                backgroundColor: .subPink1
            )
        ]
    }

    var safeActivities: [DailyActivity] {

        let server = report?.dailyActivities ?? []

        let allDays = Weekday.allCases

        return allDays.map { day in
            server.first(where: { $0.day == day }) ??
            DailyActivity(
                day: day,
                scheduleCount: 0,
                taskCount: 0,
                activityRate: 0
            )
        }
    }

    var insightItems: [WeeklyInsight] {
        (report?.insights ?? []).map { domain in
            WeeklyInsight(
                title: domain.title,
                emoji: domain.emoji,
                description: domain.content,
                borderColor: domain.type.borderColor,
                backgroundColor: domain.type.backgroundColor,
                titleColor: domain.type.titleColor
            )
        }
    }

    // 주간 비교
    var comparisonMetrics: [WeeklyComparisonMetric] {

        let report = self.report

        return [
            WeeklyComparisonMetric(
                title: "정시 도착률",
                previousValue: "-",
                currentValue: report?.onTimeRate.map { "\($0)" } ?? "-",
                diffValue: report?.onTimeDiff ?? 0
            ),
            WeeklyComparisonMetric(
                title: "할일 완료율",
                previousValue: "-",
                currentValue: report?.taskCompletionRate.map { "\($0)" } ?? "-",
                diffValue: report?.taskCompletionDiff ?? 0
            )
        ]
    }



    
}

extension WeeklyReportViewModel {

    func range(for option: PeriodOption) -> PeriodRange {
        let calendar = Calendar.current

        switch option {
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

// MARK: - API
extension WeeklyReportViewModel {
    
    @MainActor
    func fetchReport() async {
        isLoading = true
        errorMessage = nil
        
        do {
            switch selectedPeriod {
                
            case .lastWeek:
                let weekStart = selectedRange.start.toString(format: "yyyy-MM-dd")
                report = try await service.fetchWeeklyReport(
                    weekStartDate: weekStart
                )
                
            case .thisMonth:
                let month = selectedRange.start.toString(format: "yyyy-MM")
                report = try await service.fetchMonthlyReport(
                    yearMonth: month
                )
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

