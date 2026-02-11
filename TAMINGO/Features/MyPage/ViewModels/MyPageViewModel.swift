//
//  myPageViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import Foundation
import Observation



@Observable
final class MyPageViewModel {

    private let myPageService: MyPageServiceProtocol

    var myPage: MyPage?
    var errorMessage: String?
    
    var profileName: String {
        myPage?.profile.name ?? "사용자"
    }

    var profileEmail: String {
        myPage?.profile.email ?? "-"
    }

    init(myPageService: MyPageServiceProtocol = MyPageService()) {
        self.myPageService = myPageService
    }

    var weeklyMetrics: [WeeklyMetric] {
        guard let report = myPage?.weeklyReport else {
            return []
        }

        return [
            // 정시 도착률
            WeeklyMetric(
                title: "정시 도착률",
                value: "\(report.onTimeRate)%",
                subValue: report.onTimeDiff == 0
                    ? "변동 없음"
                    : report.onTimeDiff > 0
                        ? "+\(Int(report.onTimeDiff))% 상승"
                        : "\(Int(report.onTimeDiff))% 감소",
                iconName: "clock",          // 실제 에셋 이름으로 교체
                textColor: .mainMint,
                backgroundColor: .mainMint
            ),

            // 할 일 달성
            WeeklyMetric(
                title: "할 일 달성",
                value: "\(report.taskDoneCount)/\(report.taskTotalCount)개", // "6/10"
                subValue: "완료한 할 일",
                iconName: "checklist",
                textColor: .subBlue2,
                backgroundColor: .subBlue3
            ),

            // 생산성
            WeeklyMetric(
                title: "생산성",
                value: "\(report.productivityScore)점",
                subValue: report.grade.title,   // "우수 / 적정 / 보통 / 낮음"
                iconName: "chart",
                textColor: .subPink2,
                backgroundColor: .subPink1
            )
        ]
    }

    private func diffText(_ diff: Int, unit: String) -> String {
        diff == 0 ? "변동 없음" : diff > 0 ? "+\(diff)\(unit) 상승" : "\(diff)\(unit) 감소"
    }
    
    var integrationStatusText: String {
        guard let integration = myPage?.integration else {
            return "-"
        }

        if integration.linked {
            return integration.status == .active ? "연동 중" : "연동 비활성"
        } else {
            return "연동 안 됨"
        }
    }


    // 활동 시간 반환
    var activityTimeText: String {
        guard let activityTime = myPage?.settings.activityTime else {
            return "활동 시간 미설정"
        }

        return "\(activityTime.startTime.toString(format: "HH:mm")) - \(activityTime.endTime.toString(format: "HH:mm"))"
    }

    
    var transportPriorityText: String {
        let transports = myPage?.settings.transportPriority ?? []
        guard !transports.isEmpty else {
            return "이동 수단 미설정"
        }

        return transports
            .map { $0.title }
            .joined(separator: " > ")
    }

    @MainActor
    func fetchMyPage() async {
        do {
            self.myPage = try await myPageService.fetchSummary()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // MyPageViewModel
    @MainActor
    func updateActivityTime(_ activityTime: ActivityTime) {
        guard let myPage else { return }

        let updatedSettings = MyPageSettings(
            activityTime: activityTime,
            notification: myPage.settings.notification,
            transportPriority: myPage.settings.transportPriority,
            learningDataEnabled: myPage.settings.learningDataEnabled
        )

        self.myPage = MyPage(
            profile: myPage.profile,
            weeklyReport: myPage.weeklyReport,
            counts: myPage.counts,
            integration: myPage.integration,
            settings: updatedSettings
        )
    }

    // 자주 가는 장소
    var favoritePlacesText: String {
        let count = myPage?.counts.favoritePlaceCount ?? 0
        return count == 0 ? "등록된 장소 없음" : "\(count)개 등록됨"
    }

    // 알림 상태 텍스트
    var notificationStatusText: String {
        guard let notification = myPage?.settings.notification else {
            return "-"
        }
        return notification.departAlertEnabled ? "출발 알림 켜짐" : "출발 알림 꺼짐"
    }

    
    // 오차 로그 수집
    var errorLogSettingText: String {
        guard let isEnabled = myPage?.settings.learningDataEnabled.isEnabled else {
            return "-"
        }

        return isEnabled ? "오차 로그 수집 중" : "오차 로그 수집 안 함"
    }
    
}
