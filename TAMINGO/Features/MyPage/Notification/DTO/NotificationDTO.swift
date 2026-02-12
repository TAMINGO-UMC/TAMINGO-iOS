//
//  NotificationDTO.swift
//  TAMINGO
//
//  Created by 김도연 on 2/10/26.
//

struct NotificationSettingResult: Encodable, Decodable {
    let departureAlertEnabled: Bool
    let departureLeadMinutes: Int
    let latenessRiskAlertEnabled: Bool // PATCH 응답에 포함된 필드
    let realtimeTransitEnabled: Bool
    let todoProposalEnabled: Bool
    let locationMoveCheckEnabled: Bool
}

extension NotificationSettingResult: Equatable {
    static func == (lhs: NotificationSettingResult, rhs: NotificationSettingResult) -> Bool {
        return lhs.departureAlertEnabled == rhs.departureAlertEnabled &&
               lhs.departureLeadMinutes == rhs.departureLeadMinutes &&
               lhs.latenessRiskAlertEnabled == rhs.latenessRiskAlertEnabled &&
               lhs.realtimeTransitEnabled == rhs.realtimeTransitEnabled &&
               lhs.todoProposalEnabled == rhs.todoProposalEnabled &&
               lhs.locationMoveCheckEnabled == rhs.locationMoveCheckEnabled
    }
}
