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

    // MARK: - Stored Domain Models (조회 대상)
    var activityTime: ActivityTime
    var notificationSetting: NotificationSetting
    var favoritePlaces : [FavoritePlace]
    var errorLogSetting : ErrorLogSetting
    
    // MARK: - Init (Mock 기준)
    init(
        activityTime: ActivityTime = ActivityTimeMock.weekdayDefault,
        notificationSetting: NotificationSetting = NotificationSettingMock.allDisabled
    ) {
        self.activityTime = activityTime
        self.notificationSetting = notificationSetting
        self.favoritePlaces = FavoritePlaceMock.default
        self.errorLogSetting = ErrorLogSettingMock.enabled
    }

    // MARK: - 조회용
    // 활동 시간 반환
    var activityTimeText: String {
        "\(activityTime.startTime.toString(format: "HH:mm")) - \(activityTime.endTime.toString(format: "HH:mm")) "
    }
    // 자주 가는 장소
    var favoritePlacesText : String {
        favoritePlaces.isEmpty ? "등록된 장소 없음" : "\(favoritePlaces.count)개 등록됨"
    }
    // 알림 상태 텍스트
    var notificationStatusText: String {
        notificationSetting.departAlertEnabled ? "출발 알림 켜짐" : "출발 알림 꺼짐"
    }
    
    // 오차 로그 수집
    var errorLogSettingText: String {
        errorLogSetting.isEnabled ? "오차 로그 수집 중" : "오차 로그 수집 안 함"
    }
    
}
