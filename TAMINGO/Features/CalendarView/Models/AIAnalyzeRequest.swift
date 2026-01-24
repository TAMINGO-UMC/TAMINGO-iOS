//
//  ScheduleDTO.swift
//  TAMINGO
//
//  Created by 김도연 on 1/23/26.
//

import Foundation

// MARK: - [Request] AI 추론 요청
struct AIAnalyzeRequest: Codable {
    let query: String
}

// MARK: - [Response] AI 추론 결과
struct AIAnalyzeResponse: Codable {
    let title: String
    let place: String
    let category: String
    let startDateTime: Date
    let endDateTime: Date
}

// MARK: - [Request] 최종 일정 저장 요청
struct ScheduleSaveRequest: Codable {
    let title: String
    let startTime: String
    let endTime: String
    let placeName: String
    let latitude: String
    let longitude: String
    let category: String // 서버에는 "SCHOOL" 문자열로 전송
    let repeatType: String
    let repeatEndDate: String?
    let memo: String
    let relatedTodoIds: [Int]
}
