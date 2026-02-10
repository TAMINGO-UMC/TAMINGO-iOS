//
//  myPageViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import Foundation
import Observation

enum FavoritePlaceMock {

    static let `default`: [FavoritePlace] = [
        FavoritePlace(
            id: 1,
            name: "집",
            address: "서울시 노원구 광운로 21",
            latitude: 37.6195,
            longitude: 127.0598,
            weeklyVisitCount: 6
        ),
        FavoritePlace(
            id: 2,
            name: "중앙도서관",
            address: "서울시 노원구 광운로 21",
            latitude: 37.6201,
            longitude: 127.0589,
            weeklyVisitCount: 6
        )
    ]
}

@Observable
final class MyPageViewModel {
    
    // MARK: - Stored Domain Models (조회 대상)
    var activityTime: ActivityTime
    var notificationSetting: NotificationSettingResult
    var favoritePlaces : [FavoritePlace]
    var errorLogSetting : ErrorLogSetting
    
    // MARK: - Init (Mock 기준)
    init(
        activityTime: ActivityTime = ActivityTimeMock.weekdayDefault,
        notificationSetting: NotificationSettingResult = .init(
            departureAlertEnabled: false,
            departureLeadMinutes: 0,
            latenessRiskAlertEnabled: false,
            realtimeTransitEnabled: false,
            todoProposalEnabled: false,
            locationMoveCheckEnabled: false
        ),
        favoritePlaces: [FavoritePlace] = FavoritePlaceMock.default,
        errorLogSetting: ErrorLogSetting = ErrorLogSettingMock.enabled
    ) {
        self.activityTime = activityTime
        self.notificationSetting = notificationSetting
        self.favoritePlaces = favoritePlaces
        self.errorLogSetting = errorLogSetting
    }

    // MARK: - 조회용
    
    // 캘린더 연동 여부
//    var calendarSyncStatusText: String {
//        
//    }
    
    // 활동 시간 반환
    var activityTimeText: String {
        "\(activityTime.startTime.toString(format: "HH:mm")) - \(activityTime.endTime.toString(format: "HH:mm"))"
    }
    // 자주 가는 장소
    var favoritePlacesText : String {
        favoritePlaces.isEmpty ? "등록된 장소 없음" : "\(favoritePlaces.count)개 등록됨"
    }
    // 알림 상태 텍스트
    var notificationStatusText: String {
        notificationSetting.departureAlertEnabled ? "출발 알림 켜짐" : "출발 알림 꺼짐"
    }
    
    // 오차 로그 수집
    var errorLogSettingText: String {
        errorLogSetting.isEnabled ? "오차 로그 수집 중" : "오차 로그 수집 안 함"
    }
    
}
