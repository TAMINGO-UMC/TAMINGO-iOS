//
//  TodoDTO.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/5/26.
//  Updated: linkedSchedule 타입 불일치 수정 (Array -> Single Object)
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

// MARK: - 3. 할 일 수정 Response
struct TodoUpdateResponseDTO: Codable {
    let todoId: Int
    let actualTargetDate: String?  // ✅ 서버가 강제 변환한 실제 날짜
}


// MARK: - 4. AI 추론 Response
struct TodoAIInferenceResponseDTO: Codable {
    let todoInfo: TodoInfoDTO
    
    struct TodoInfoDTO: Codable {
        let category: String?
        let placeName: String?
        let address: String?
        let latitude: Double?
        let longitude: Double?
        let duration: Int
    }
}

// MARK: - 5. 장소 수정 시 일정 추천 Request
struct RecommendSchedulesRequestDTO: Codable {
    let placeName: String
    let address: String
    let latitude: Double
    let longitude: Double
}

// MARK: - 5. 장소 수정 시 일정 추천 Response
struct RecommendSchedulesResponseDTO: Codable {
    let nearbyTodos: [ScheduleItemDTO]
    let candidateTodos: [ScheduleItemDTO]
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
    let categoryColor: String?  // ✅ 서버가 제공할 수도 있는 색상 필드 추가
    let repeatType: String
    let repeatEndDate: String?
    
    // 🚨 수정됨: 배열([LinkedScheduleDTO]?)이 아니라 단일 객체(LinkedScheduleDTO?)로 변경
    let linkedSchedule: LinkedScheduleDTO?
    
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
            category: category ?? "미지정",
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
        // ✅ 서버가 제공하는 categoryColor를 최우선으로 사용
        let color = Color(hex: categoryColor)
        
        return TodoItem(
            id: todoId,
            title: title,
            category: categoryName,
            categoryColor: color,  // ✅ 서버 Hex 색상 사용
            isCompleted: isChecked,
            date: nil
        )
    }
}

extension TodoDetailResponseDTO {
    func toTodoItem() -> TodoItem {
        // ✅ linkedSchedule을 relatedSchedules 배열로 변환 (isSelected = true)
        var linkedSchedules: [TodoRelatedScheduleItem] = []
        
        if let schedule = linkedSchedule {
            linkedSchedules.append(
                TodoRelatedScheduleItem(
                    title: schedule.title,
                    location: schedule.placeName ?? "",
                    isSelected: true,  // ✅ 연결된 스케줄은 선택된 상태
                    scheduleId: schedule.scheduleId
                )
            )
        }
        
        // ✅ candidateSchedules를 미선택 상태로 추가
        let candidateScheduleItems = candidateSchedules.map { schedule in
            TodoRelatedScheduleItem(
                title: schedule.title,
                location: schedule.placeName ?? "",
                isSelected: false,  // ✅ 후보 스케줄은 미선택 상태
                scheduleId: schedule.scheduleId
            )
        }
        
        // ✅ 연결된 스케줄 + 후보 스케줄 합치기
        let allSchedules = linkedSchedules + candidateScheduleItems
        
        print("🔄 toTodoItem 변환")
        print("  - linkedSchedule: \(linkedSchedule?.scheduleId ?? -1)")
        print("  - 전체 스케줄 수: \(allSchedules.count)")
        print("  - 선택된 스케줄 수: \(allSchedules.filter { $0.isSelected }.count)")
        
        // ✅ 서버 색상이 있으면 사용, 없으면 클라이언트 매핑 사용
        let color: Color
        if let serverColor = categoryColor {
            color = Color(hex: serverColor)
            print("  - 서버 색상 사용: \(serverColor)")
        } else {
            color = CategoryHelper.color(for: category)
            print("  - 클라이언트 매핑 색상 사용")
        }
        
        return TodoItem(
            id: todoId,
            title: title,
            category: category,
            categoryColor: color,
            isCompleted: false,
            date: targetDate?.toDates(),
            placeName: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            estimatedMinutes: duration,
            relatedSchedules: allSchedules,
            linkedScheduleId: linkedSchedule?.scheduleId,
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
        
        // ✅ 날짜 변환 로그 추가
        let targetDateString = date?.toAPIDateString()
        print("📤 toUpdateRequestDTO 생성")
        print("  - item.date: \(date?.toAPIDateString() ?? "nil")")
        print("  - targetDate (전송값): \(targetDateString ?? "nil")")
        print("  - linkedScheduleId: \(linkedScheduleId ?? -1)")
        
        return TodoUpdateRequestDTO(
            title: title,
            targetDate: targetDateString,
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
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let color: Color
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
