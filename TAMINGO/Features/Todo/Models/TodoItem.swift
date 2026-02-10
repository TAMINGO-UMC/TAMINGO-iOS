//
//  TodoItem.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: 2/9/26 - Equatable 프로토콜 추가
//

import SwiftUI

struct TodoItem: Identifiable, Equatable {
    let id: Int?
    let localId = UUID()
    var title: String
    var category: String
    var categoryColor: Color
    var isCompleted: Bool
    var date: Date?
    var placeName: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var estimatedMinutes: Int?
    var relatedSchedules: [TodoRelatedScheduleItem] = []
    var linkedScheduleId: Int?
    var isRoutineEnabled: Bool = false
    var routineType: TodoRoutineType = .daily
    var routineEndDate: Date?
    var aiSource: AISourceInfo?
    
    struct AISourceInfo: Equatable {
        let aiSuggestedCategoryName: String
        let aiSuggestedPlaceName: String?
        let aiSuggestedDuration: Int
    }
    
    // MARK: - Equatable 구현
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.localId == rhs.localId &&
               lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.isCompleted == rhs.isCompleted &&
               lhs.date == rhs.date
    }
}
