//
//  WeeklyReport.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation

enum ProductivityGrade {
    case excellent   // 우수
    case good        // 적정
    case fair        // 보통
    case low         // 낮음
}

extension ProductivityGrade {
    var title: String {
        switch self {
        case .excellent: return "우수"
        case .good: return "적정"
        case .fair: return "보통"
        case .low: return "낮음"
        }
    }
}

extension ProductivityGrade {
    init?(serverValue: String) {
        switch serverValue {
        case "EXCELLENT": self = .excellent
        case "GOOD": self = .good
        case "FAIR": self = .fair
        case "LOW": self = .low
        default: return nil
        }
    }
}


struct WeeklyReportSummary {
    let period: PeriodRange
    let onTimeRate: Int?
    let onTimeDiff: Int?
    let taskDoneCount: Int?
    let taskTotalCount: Int?
    let productivityScore: Int?
    let grade: ProductivityGrade?
}



struct WeeklyReportDetail {
    let period: PeriodRange

    let onTimeRate: Int?
    let onTimeDiff: Int?

    let taskCompletionRate: Int?
    let taskCompletionDiff: Int?
    let taskDoneCount: Int?
    let taskTotalCount: Int?

    let productivityScore: Int?
    let grade: ProductivityGrade?

    let dailyActivities: [DailyActivity]
    let insights: [WeeklyInsightDomain]
}



struct DailyActivity {
    let day: Weekday
    let scheduleCount: Int
    let taskCount: Int
    let activityRate: Int
}

struct WeeklyInsightDomain {
    let type: InsightType
    let title: String
    let content: String
}


