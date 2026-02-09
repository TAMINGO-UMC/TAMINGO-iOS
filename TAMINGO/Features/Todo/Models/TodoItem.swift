//
//  TodoItem.swift
//  TAMINGO
//
//  Created by Claude on 2/5/26.
//  Updated: 2/8/26 - CategoryColor enum 사용
//

import Foundation

struct TodoItem: Identifiable {
    let id: Int?
    let localId = UUID()
    var title: String
    var category: String
    var categoryColor: CategoryColor  // CategoryColor enum 사용
    var isCompleted: Bool
    var date: Date?
    
    // 장소 정보
    var placeName: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    // 예상 소요시간 (단위: 분)
    var estimatedMinutes: Int?
    
    // 관련 일정
    var relatedSchedules: [TodoRelatedScheduleItem] = []
    var linkedScheduleId: Int?
    
    // 루틴
    var isRoutineEnabled: Bool = false
    var routineType: TodoRoutineType = .daily
    var routineEndDate: Date? = nil
    
    // AI 추론 원본 정보
    var aiSource: AISourceInfo?
    
    struct AISourceInfo {
        let aiSuggestedCategoryName: String
        let aiSuggestedPlaceName: String?
        let aiSuggestedDuration: Int
    }
}
