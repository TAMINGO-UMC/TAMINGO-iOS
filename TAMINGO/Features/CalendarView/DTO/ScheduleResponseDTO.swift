//
//  ScheduleResponseDTO.swift
//  TAMINGO
//
//  Created by 김도연 on 1/30/26.
//

import Foundation

// MARK: - 일정 추가
struct ScheduleCreationResponseDTO: Decodable {
    let scheduleId: Int
}

// MARK: - 일정 목록
struct ScheduleListDTO: Decodable {
    let scheduleId: Int
    let title: String
    let startTime: String
    let endTime: String
    let placeName: String
    let category: String
}

// MARK: - 일정 상세 정보 (일정 상세 조회 및 생성 결과용)
struct ScheduleResponseDTO: Decodable {
    let scheduleId: Int
    let title: String
    let scheduleDate: String
    let startTime: String
    let endTime: String
    let placeName: String
    let address: String
    let latitude: Double
    let longitude: Double
    let category: String
    let repeatType: String
    let repeatEndDate: String
    let memo: String
    let linkedTodos: [TodoSummaryDTO]
    let candidateTodos: [TodoSummaryDTO]
}

// MARK: - AI 추론 결과 응답 (ai-inference)
struct AIInferenceResponseDTO: Decodable {
    let aiInference: AIInferenceData
    let nearbyTodos: [TodoSummaryDTO]
    let candidateTodos: [TodoSummaryDTO]
    let isFavoriteRecommendation: Bool
}

struct AIInferenceData: Decodable {
    let placeName: String
    let address: String
    let latitude: Double
    let longitude: Double
    let category: String
}

// MARK: - 할 일 요약 (내부 리스트용)
struct TodoSummaryDTO: Decodable {
    let todoId: Int
    let title: String
    let placeName: String?
}

// MARK: - 카테고리 정보
struct ScheduleCategoryDTO: Decodable, Identifiable{
    let id: Int
    let name: String
    let iconCode: String
    let colorCode: String
}

// MARK: - 내 장소 가져오기
struct MyPlaceDTO: Decodable, Identifiable {
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}
