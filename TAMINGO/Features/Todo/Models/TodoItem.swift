//
//  TodoItem.swift
//  TAMINGO
//
//  Created by Claude on 2/5/26.
//

import Foundation

struct TodoItem: Identifiable {
    let id: Int?  // API에서 받은 todoId (생성 전에는 nil)
    let localId = UUID()  // 로컬 식별용
    var title: String
    var category: String
    var categoryColor: CategoryColor
    var isCompleted: Bool
    var date: Date?
    
    // 장소 정보
    var placeName: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    // 예상 소요시간 (단위: 분)
    var estimatedMinutes: Int?
    
    // Sheet "일정 연결"에서 체크한 관련 일정 (TodoRelatedScheduleItem 사용)
    var relatedSchedules: [TodoRelatedScheduleItem] = []
    var linkedScheduleId: Int?  // API 연동용 단일 일정 ID
    
    // MARK: - 루틴 (TodoRoutineType 사용)
    var isRoutineEnabled: Bool = false
    var routineType: TodoRoutineType = .daily
    var routineEndDate: Date? = nil
    
    // MARK: - AI 추론 원본 정보 (서버 전송용)
    var aiSource: AISourceInfo?
    
    struct AISourceInfo {
        let aiSuggestedCategoryName: String
        let aiSuggestedPlaceName: String?
        let aiSuggestedDuration: Int
    }
    
    // MARK: - 카테고리 색상
    enum CategoryColor {
        case daily  // 일상 - 파란색
        case life   // 생활 - 초록색
        case work   // 업무 - 주황색
        
        var textColor: (r: Double, g: Double, b: Double, a: Double) {
            switch self {
            case .daily: return (103, 126, 197, 1)
            case .life: return (85, 181, 111, 1)
            case .work: return (255, 149, 0, 1)
            }
        }
        
        var backgroundColor: (r: Double, g: Double, b: Double, a: Double) {
            switch self {
            case .daily: return (231, 238, 251, 1)
            case .life: return (234, 251, 231, 1)
            case .work: return (255, 245, 230, 1)
            }
        }
        
        static func from(category: String) -> CategoryColor {
            switch category {
            case "생활": return .life
            case "업무": return .work
            default: return .daily
            }
        }
    }
}
