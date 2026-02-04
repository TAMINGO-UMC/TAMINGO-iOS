//
//  TodoItem.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//
import Foundation

struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var category: String
    var categoryColor: CategoryColor
    var isCompleted: Bool
    var date: Date?
    
    // AI 추론 또는 편집에서 저장된 장소 (첫 생성 시 nil → 편집 시트에서 AI 기본값 표시)
    var location: String? = nil
    //AI 추론 또는 편집에서 저장된 예상 소요시간 (단위: 분) (첫 생성 시 nil → 편집 시트에서 AI 기본값 표시)
    var estimatedMinutes: Int? = nil
    // Sheet "일정 연결"에서 체크한 관련 일정 (저장 시에만 업데이트)
    var relatedSchedules: [RelatedScheduleItem] = []
    
    // MARK: - 루틴
    var isRoutineEnabled: Bool = false
    var routineType: RoutineType = .daily
    var routineEndDate: Date? = nil       // nil = 종료 날짜 미설정
    
    enum CategoryColor {
        case daily // 일상 - 파란색
        case life  // 생활 - 초록색
        
        var textColor: (r: Double, g: Double, b: Double, a: Double) {
            switch self {
            case .daily: return (103, 126, 197, 1)
            case .life: return (85, 181, 111, 1)
            }
        }
        
        var backgroundColor: (r: Double, g: Double, b: Double, a: Double) {
            switch self {
            case .daily: return (231, 238, 251, 1)
            case .life: return (234, 251, 231, 1)
            }
        }
    }
}
