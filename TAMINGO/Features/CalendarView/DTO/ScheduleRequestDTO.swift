//
//  ScheduleRequestDTO.swift
//  TAMINGO
//
//  Created by 김도연 on 1/30/26.
//

import Foundation

// 일정 생성 및 수정을 위한 Request Body
struct ScheduleRequestDTO: Encodable {
    let title: String
    let scheduleDate: String
    let startTime: String
    let endTime: String
    let placeName: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let scheduleCategoryId: Int?
    let memo: String
    let repeatType: String
    let repeatEndDate: String?
    let linkedTodoIds: [Int]
    let aiInferenceSource: AIInferenceSource?
}

struct AIInferenceSource: Encodable {
    var aiSuggestedPlaceName: String
    var aiSuggestedCategoryName: String
}

struct ScheduleEditDTO: Encodable {
    let title: String
    let scheduleDate: String
    let startTime: String
    let endTime: String
    let placeName: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let scheduleCategoryId: Int?
    let memo: String
    let repeatType: String
    let repeatEndDate: String?
    let linkedTodoIds: [Int]
}

struct addPlaceDTO: Encodable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let isAiSuggested: Bool
}
