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
    static func from(score: Int) -> ProductivityGrade {
        let clampedScore = min(max(score, 0), 100)

        switch clampedScore {
        case 80...100:
            return .excellent
        case 60..<80:
            return .good
        case 40..<60:
            return .fair
        default:
            return .low
        }
    }
}


struct WeeklyReport {
    let period: PeriodRange
    let onTimeRate: Int?
    let onTimeDiff: Int?
    let taskDoneCount: Int?
    let taskTotalCount: Int?
    let productivityScore: Int?
    let grade: ProductivityGrade?
}


extension WeeklyReport {

    var periodText: String {
        "\(period.start) ~ \(period.end)"
    }

    var taskProgressText: String {
        "\(taskDoneCount)/\(taskTotalCount)"
    }
}


struct WeeklyReportDetail {
    let period: PeriodRange

    let onTimeRate: Int
    let onTimeDiff: Int

    let taskCompletionRate: Int
    let taskCompletionDiff: Int
    let taskDoneCount: Int
    let taskTotalCount: Int

    let productivityScore: Int
    let grade: ProductivityGrade

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


