//
//  RouteResultModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

struct RouteResultModel {
    let totalDuration: Int
    let startTime: Date
    let arriveTime: Date
    let startPlaceName: String
    let arrivePlaceName: String
    let wayPoints: [String]
    let legs: [RouteLegModel]
    
    
    var totalMinutesText: String {
        "\(totalDuration)분 소요"
    }

    var startTimeText: String {
        startTime.toKoreanTime()
    }

    var endTimeText: String {
        arriveTime.toKoreanTime()
    }
}

extension Date {
    func toKoreanTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "a h:mm"   // 오전 9:40

        return formatter.string(from: self)
    }
}
