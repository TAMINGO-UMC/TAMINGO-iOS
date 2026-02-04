//
//  TodoEditViewModel.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//
import SwiftUI

@Observable
class TodoEditViewModel {
    var title: String
    // nil = 날짜 미지정. CalendarSheet 열기 시 nil이면 오늘 날짜로 표시
    // 확인하지 않고 닫으면 다시 nil로 복원됨
    var selectedDate: Date?
    var location: String
    var duration: String
    var category: String
    var relatedSchedules: [RelatedScheduleItem]
    var isRoutineEnabled: Bool
    var selectedRoutine: RoutineType
    var routineEndDate: Date
    var hasEndDate: Bool
    
    var isLocationAIGenerated: Bool
    var isDurationAIGenerated: Bool
    var isCategoryAIGenerated: Bool
    var isScheduleAIGenerated: Bool
    
    var showingDatePicker: Bool = false
    var isLocationExpanded: Bool = false
    var locationSearchText: String = ""
    var showingDurationPicker: Bool = false
    var isScheduleExpanded: Bool = false
    
    // Duration picker values
    var selectedHour: Int = 1
    var selectedMinute: Int = 0
    var durationDate: Date = Date()
    
    // 내 장소 목록
    var myLocations: [MyLocation] = [
        MyLocation(icon: "house.fill", name: "집", color: .blue),
        MyLocation(icon: "building.2.fill", name: "학교", color: .green),
        MyLocation(icon: "briefcase.fill", name: "회사", color: .orange),
        MyLocation(icon: "cart.fill", name: "도서관", color: .yellow),
        MyLocation(icon: "cup.and.saucer.fill", name: "카페", color: .brown)
    ]
    
    // 날짜 표시 문자열
    var formattedDate: String {
        guard let date = selectedDate else {
            return "- - - -, - -, - -"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // MARK: - init
    // TodoItem의 실제 저장된 값으로 초기화
    // - date가 nil이면 selectedDate도 nil 유지 → Sheet에서 "미지정" 표시
    // - location / duration 등은 item 저장값 우선, 없으면 AI 기본값
    // - 루틴 필드도 item에서 복원
    init(item: TodoItem) {
        self.title = item.title
        self.selectedDate = item.date
        
        self.location = item.location ?? "학교"
        self.isLocationAIGenerated = (item.location == nil)
        
        self.duration = TodoEditViewModel.formatDuration(minutes: item.estimatedMinutes)
        self.isDurationAIGenerated = (item.estimatedMinutes == nil)
        
        self.category = item.category
        self.isCategoryAIGenerated = item.category.isEmpty
        
        // 관련 일정: item에 저장된 것이 있으면 isSelected = true로 복원
        let savedTitles = Set(item.relatedSchedules.map { $0.title })
        self.relatedSchedules = [
            RelatedScheduleItem(title: "팀플 미팅",  location: "광운대학교",         isSelected: savedTitles.contains("팀플 미팅")),
            RelatedScheduleItem(title: "동아리",     location: "메가커피 광운대점",   isSelected: savedTitles.contains("동아리"))
        ]
        
        // 루틴: item에서 복원
        self.isRoutineEnabled = item.isRoutineEnabled
        self.selectedRoutine  = item.routineType
        self.hasEndDate       = item.routineEndDate != nil
        self.routineEndDate   = item.routineEndDate
            ?? Calendar.current.date(byAdding: .month, value: 1, to: Date())
            ?? Date()
        
        self.isScheduleAIGenerated = true
        
        parseDuration()
        
        var components = DateComponents()
        components.hour = selectedHour
        components.minute = selectedMinute
        self.durationDate = Calendar.current.date(from: components) ?? Date()
    }
    
    // MARK: - duration 파싱
    func parseDuration() {
        guard !duration.isEmpty else { return }
        for component in duration.components(separatedBy: " ") {
            if component.contains("시간"),
               let hour = Int(component.replacingOccurrences(of: "시간", with: "")) {
                selectedHour = hour
            } else if component.contains("분"),
                      let minute = Int(component.replacingOccurrences(of: "분", with: "")) {
                selectedMinute = minute
            }
        }
    }
    
    // MARK: - 저장
    /// 편집된 모든 필드를 TodoItem에 기록
    /// - selectedDate가 nil이면 item.date도 nil → "날짜 미지정" 섹션으로 이동
    /// - 체크된 relatedSchedules도 item에 저장
    /// - 루틴 상태도 item에 저장
    func saveChanges(to item: inout TodoItem) {
        item.title            = title
        item.date             = selectedDate
        item.location         = location
        item.category         = category
        item.estimatedMinutes = parsedTotalMinutes
        item.relatedSchedules = relatedSchedules.filter { $0.isSelected }
        
        // 루틴 저장
        item.isRoutineEnabled = isRoutineEnabled
        item.routineType      = selectedRoutine
        item.routineEndDate   = hasEndDate ? routineEndDate : nil
    }
    
    // MARK: - 헬퍼
    private var parsedTotalMinutes: Int {
        return selectedHour * 60 + selectedMinute
    }
    
    static func formatDuration(minutes: Int?) -> String {
        guard let minutes = minutes, minutes > 0 else {
            return "1시간 10분"  // AI 기본값
        }
        let h = minutes / 60
        let m = minutes % 60
        if h > 0 && m > 0 { return "\(h)시간 \(m)분" }
        if h > 0           { return "\(h)시간" }
        return "\(m)분"
    }
}

// MARK: - Supporting Models
struct RelatedScheduleItem: Identifiable {
    let id = UUID()
    var title: String
    var location: String
    var isSelected: Bool
}

enum RoutineType: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case daily   = "매일"
    case weekly  = "매주"
    case monthly = "매달"
}

struct MyLocation: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let color: Color
}
