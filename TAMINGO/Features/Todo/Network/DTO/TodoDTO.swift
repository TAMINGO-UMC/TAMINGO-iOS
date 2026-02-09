//
//  TodoDTO.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/5/26.
//  Updated: 2/8/26 - recommend-schedules DTO 추가
//

import Foundation
import SwiftUI

// MARK: - 1. 내장소 가져오기 Response
struct MyPlacesDTO: Codable {
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

// MARK: - 2. 할 일 생성 Request
struct TodoCreateRequestDTO: Codable {
    let title: String
    let targetDate: String
    let todoCategoryId: Int
    let placeName: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let duration: Int
    let aiSource: TodoAISourceDTO
}

struct TodoAISourceDTO: Codable {
    let aiSuggestedCategoryName: String
    let aiSuggestedPlaceName: String?
    let aiSuggestedDuration: Int
}

// MARK: - 2. 할 일 생성 Response
struct TodoCreateResponseDTO: Codable {
    let todoId: Int
}

// MARK: - 3. 할 일 수정 Request
struct TodoUpdateRequestDTO: Codable {
    let title: String
    let targetDate: String?
    let placeName: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let duration: Int
    let todoCategoryId: Int
    let repeatType: String
    let repeatEndDate: String?
    let linkedScheduleId: Int?
}

// MARK: - 4. AI 추론 Response
struct TodoAIInferenceResponseDTO: Codable {
    let todoInfo: TodoInfoDTO
    
    struct TodoInfoDTO: Codable {
        let category: String
        let placeName: String?
        let address: String?
        let latitude: Double?
        let longitude: Double?
        let duration: Int
    }
}

// MARK: - 5. 장소 수정 시 일정 추천 Request (NEW)
struct RecommendSchedulesRequestDTO: Codable {
    let placeName: String
    let address: String
    let latitude: Double
    let longitude: Double
}

// MARK: - 5. 장소 수정 시 일정 추천 Response (NEW)
struct RecommendSchedulesResponseDTO: Codable {
    let nearbySchedules: [ScheduleItemDTO]
    let candidateSchedules: [ScheduleItemDTO]
    let isFavoriteRecommendation: Bool
    
    struct ScheduleItemDTO: Codable {
        let scheduleId: Int
        let title: String
        let placeName: String?
    }
}

// MARK: - 6. 할일 목록 조회 Response
struct TodoListResponseDTO: Codable {
    let dailyTodos: [TodoItemDTO]
    let backlogTodos: [TodoItemDTO]
    
    struct TodoItemDTO: Codable {
        let todoId: Int
        let title: String
        let categoryName: String
        let categoryColor: String
        let isChecked: Bool
    }
}

// MARK: - 7. 할일 상세 조회 Response
struct TodoDetailResponseDTO: Codable {
    let todoId: Int
    let title: String
    let targetDate: String?
    let placeName: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let duration: Int
    let category: String
    let repeatType: String
    let repeatEndDate: String?
    let linkedSchedule: [LinkedScheduleDTO]
    let candidateSchedules: [CandidateScheduleDTO]
    let isFavoriteRecommendation: Bool
    
    struct LinkedScheduleDTO: Codable {
        let scheduleId: Int
        let title: String
        let placeName: String?
    }
    
    struct CandidateScheduleDTO: Codable {
        let scheduleId: Int
        let title: String
        let placeName: String?
    }
}

// MARK: - 8. 할일 완료 체크 Request
struct TodoCompletionRequestDTO: Codable {
    let isChecked: Bool
}

// MARK: - DTO → Model 변환

extension MyPlacesDTO {
    func toTodoMyLocation() -> TodoMyLocation {
        // ID 기반 색상 부여
        let color: Color = {
            switch id % 5 {
            case 0: return .blue
            case 1: return .green
            case 2: return .orange
            case 3: return .purple
            default: return .pink
            }
        }()
        
        return TodoMyLocation(
            id: id,
            name: name,
            address: address,
            latitude: latitude,
            longitude: longitude,
            color: color
        )
    }
}

extension TodoAIInferenceResponseDTO.TodoInfoDTO {
    func toAIInferenceResult() -> AIInferenceResult {
        AIInferenceResult(
            category: category,
            placeName: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            duration: duration
        )
    }
}

extension RecommendSchedulesResponseDTO.ScheduleItemDTO {
    func toTodoRelatedScheduleItem() -> TodoRelatedScheduleItem {
        TodoRelatedScheduleItem(
            title: title,
            location: placeName ?? "",
            isSelected: false,
            scheduleId: scheduleId
        )
    }
}

extension TodoListResponseDTO.TodoItemDTO {
    func toTodoItem() -> TodoItem {
        let categoryColorEnum = CategoryColor(rawValue: categoryColor) ?? .mint
        
        return TodoItem(
            id: todoId,
            title: title,
            category: categoryName,
            categoryColor: categoryColorEnum,
            isCompleted: isChecked,
            date: nil
        )
    }
}

extension TodoDetailResponseDTO {
    func toTodoItem() -> TodoItem {
        let linkedSchedules = linkedSchedule.map { schedule in
            TodoRelatedScheduleItem(
                title: schedule.title,
                location: schedule.placeName ?? "",
                isSelected: true,
                scheduleId: schedule.scheduleId
            )
        }
        
        let candidateScheduleItems = candidateSchedules.map { schedule in
            TodoRelatedScheduleItem(
                title: schedule.title,
                location: schedule.placeName ?? "",
                isSelected: false,
                scheduleId: schedule.scheduleId
            )
        }
        
        let allSchedules = linkedSchedules + candidateScheduleItems
        
        let categoryColorEnum: CategoryColor = {
            switch category {
            case "일상": return .mint
            case "생활": return .lightMint
            case "업무": return .peach
            default: return .mint
            }
        }()
        
        return TodoItem(
            id: todoId,
            title: title,
            category: category,
            categoryColor: categoryColorEnum,
            isCompleted: false,
            date: targetDate?.toDates(),
            placeName: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            estimatedMinutes: duration,
            relatedSchedules: allSchedules,
            linkedScheduleId: linkedSchedule.first?.scheduleId,
            isRoutineEnabled: repeatType != "NONE",
            routineType: TodoRoutineType.from(apiString: repeatType),
            routineEndDate: repeatEndDate?.toDates(),
            aiSource: nil
        )
    }
}

// MARK: - Model → DTO 변환

extension TodoItem {
    func toCreateRequestDTO(todoCategoryId: Int) -> TodoCreateRequestDTO {
        TodoCreateRequestDTO(
            title: title,
            targetDate: date?.toAPIDateString() ?? Date().toAPIDateString(),
            todoCategoryId: todoCategoryId,
            placeName: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            duration: estimatedMinutes ?? 0,
            aiSource: TodoAISourceDTO(
                aiSuggestedCategoryName: aiSource?.aiSuggestedCategoryName ?? category,
                aiSuggestedPlaceName: aiSource?.aiSuggestedPlaceName ?? placeName,
                aiSuggestedDuration: aiSource?.aiSuggestedDuration ?? estimatedMinutes ?? 0
            )
        )
    }
    
    func toUpdateRequestDTO(todoCategoryId: Int) -> TodoUpdateRequestDTO {
        let repeatType: String
        if isRoutineEnabled {
            repeatType = routineType.apiString
        } else {
            repeatType = "NONE"
        }
        
        return TodoUpdateRequestDTO(
            title: title,
            targetDate: date?.toAPIDateString(),
            placeName: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            duration: estimatedMinutes ?? 0,
            todoCategoryId: todoCategoryId,
            repeatType: repeatType,
            repeatEndDate: isRoutineEnabled ? routineEndDate?.toAPIDateString() : nil,
            linkedScheduleId: linkedScheduleId
        )
    }
}

// MARK: - Helper Extensions

extension Date {
    func toAPIDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
}

extension String {
    func toDates() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.date(from: self)
    }
}

// MARK: - Todo 전용 모델

struct TodoMyLocation: Identifiable {
    let id: Int  // 서버 ID 추가
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let color: Color  // ID 기반 색상
}

struct TodoRelatedScheduleItem: Identifiable {
    let id = UUID()
    var title: String
    var location: String
    var isSelected: Bool
    var scheduleId: Int?
}

enum TodoRoutineType: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case daily = "매일"
    case weekly = "매주"
    case monthly = "매달"
    
    var apiString: String {
        switch self {
        case .daily: return "DAILY"
        case .weekly: return "WEEKLY"
        case .monthly: return "MONTHLY"
        }
    }
    
    static func from(apiString: String) -> TodoRoutineType {
        switch apiString {
        case "DAILY": return .daily
        case "WEEKLY": return .weekly
        case "MONTHLY": return .monthly
        default: return .daily
        }
    }
}
