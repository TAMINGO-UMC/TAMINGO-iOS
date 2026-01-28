//
//  ScheduleItem.swift
//  TAMINGO
//
//  Created by 김도연 on 1/18/26.
//

import Foundation
import SwiftUI

struct ScheduleItem: Identifiable, Codable {
    let id: Int
    var title: String
    var place: String
    
    var category: ScheduleCategory
    
    var startDateTime: Date
    var endDateTime: Date
    
    var memo: String?
    var latitude: String?
    var longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "scheduleId"
        case title
        case place = "placeName"
        case category
        case startDateTime = "startTime"
        case endDateTime = "endTime"
        case memo, latitude, longitude
    }
    
    // MARK: - Helper
    
    // 이제 색상은 category 안에 있으므로 이렇게 접근합니다.
    var color: Color {
        return category.color
    }
    // 시간 문자열 변환 (예: "09:40")
    var startTimeString: String {
        return startDateTime.toString(format: "HH:mm")
    }
    
    // 시간 문자열 변환 (예: "10:40")
    var endTimeString: String {
        return endDateTime.toString(format: "HH:mm")
    }
}
