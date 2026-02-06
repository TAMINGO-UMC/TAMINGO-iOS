//
//  TodoDTO.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/5/26.
//

import Foundation
import SwiftUI

// MARK: - 1. 내장소 가져오기 Response
// Schedule의 MyPlaceDTO를 공유하여 사용

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

// Todo 전용 AI Source DTO (Schedule의 AIInferenceSource와 구분)
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

// MARK: - 4. AI 추론 Response (Todo 전용)
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

// MARK: - 5. 자주 가는 장소 목록 조회 Response
struct FrequentPlacesResponseDTO: Codable {
    let places: [FrequentPlaceDTO]
}

struct FrequentPlaceDTO: Codable {
    let placeId: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let weeklyVisitCount: Int
}

// MARK: - 6. 장소 선택 시 관련 할일 조회 Request
struct RelatedTodosRequestDTO: Codable {
    let placeName: String
    let latitude: Double
    let longitude: Double
}

// MARK: - 6. 장소 선택 시 관련 할일 조회 Response
struct RelatedTodosResponseDTO: Codable {
    let nearbyTodos: [NearbyTodoDTO]
    let candidateTodos: [CandidateTodoDTO]
    let isFavoriteRecommendation: Bool
    
    struct NearbyTodoDTO: Codable {
        let todoId: Int
        let title: String
        let placeName: String?
    }
    
    struct CandidateTodoDTO: Codable {
        let todoId: Int
        let title: String
        let placeName: String?
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

// MARK: - DTO → Model 변환 Extension

extension MyPlaceDTO {
    /// Todo에서 사용하는 MyLocation으로 변환
    func toTodoMyLocation() -> TodoMyLocation {
        TodoMyLocation(
            icon: "mappin.circle.fill",
            name: name,
            address: address,
            latitude: latitude,
            longitude: longitude,
            color: .blue
        )
    }
}

extension FrequentPlaceDTO {
    func toTodoMyLocation() -> TodoMyLocation {
        let icon: String
        let color: Color
        
        switch weeklyVisitCount {
        case 6...:
            icon = "star.fill"
            color = .yellow
        case 4..<6:
            icon = "house.fill"
            color = .blue
        case 2..<4:
            icon = "building.2.fill"
            color = .green
        default:
            icon = "mappin.circle.fill"
            color = .gray
        }
        
        return TodoMyLocation(
            icon: icon,
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
        
        return TodoItem(
            id: todoId,
            title: title,
            category: category,
            categoryColor: TodoItem.CategoryColor.from(category: category),
            isCompleted: false,
            date: targetDate?.toDate(),
            placeName: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            estimatedMinutes: duration,
            relatedSchedules: allSchedules,
            linkedScheduleId: linkedSchedule.first?.scheduleId,
            isRoutineEnabled: repeatType != "NONE",
            routineType: TodoRoutineType.from(apiString: repeatType),
            routineEndDate: repeatEndDate?.toDate(),
            aiSource: nil
        )
    }
}

// MARK: - Model → DTO 변환 Extension

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

// MARK: - Helper Extensions (날짜 변환)
extension Date {
    func toAPIDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
}

// MARK: - Todo 전용 모델 (Schedule과 구분)

/// Todo에서 사용하는 장소 모델 (Schedule의 것과 구분)
struct TodoMyLocation: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let color: Color
}

/// Todo에서 사용하는 관련 일정 아이템 (Schedule과 구분)
struct TodoRelatedScheduleItem: Identifiable {
    let id = UUID()
    var title: String
    var location: String
    var isSelected: Bool
    var scheduleId: Int?
}

/// Todo 전용 루틴 타입 (Schedule의 RepeatType과 구분)
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
