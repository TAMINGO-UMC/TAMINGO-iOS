//
//  TodoEditViewModel.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: 2/9/26 - 날짜 미지정 처리 및 AI category null 처리
//  Updated: 2/12/26 - AIInferenceResult 파라미터 누락 수정
//

import SwiftUI

@Observable
class TodoEditViewModel {
    var title: String
    var selectedDate: Date? // ✅ 날짜 미지정 시 nil 유지
    var placeName: String
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var duration: String
    var category: String
    var relatedSchedules: [TodoRelatedScheduleItem]
    var isRoutineEnabled: Bool
    var selectedRoutine: TodoRoutineType
    var routineEndDate: Date
    var hasEndDate: Bool
    
    var isLocationAIGenerated: Bool
    var isDurationAIGenerated: Bool
    var isCategoryAIGenerated: Bool
    var isScheduleAIGenerated: Bool
    
    var originalAISource: TodoItem.AISourceInfo?
    
    var isInferringCategory: Bool = false
    var isRecommendingSchedules: Bool = false
    
    var showingDatePicker: Bool = false
    var isLocationExpanded: Bool = false
    var locationSearchText: String = ""
    var showingDurationPicker: Bool = false
    var isScheduleExpanded: Bool = false
    var isCategoryExpanded: Bool = false
    
    var selectedHour: Int = 1
    var selectedMinute: Int = 0
    var durationDate: Date = Date()
    
    var myLocations: [TodoMyLocation] = []
    var isFavoriteRecommendation: Bool = false
    var availableCategories: [TodoCategory] = []  // TodoCategory 사용
    
    var aiInferenceDisplay: AIInferenceResult? {
            guard !isCategoryAIGenerated || !isLocationAIGenerated || !isDurationAIGenerated else {
                return nil
            }
        let matchedCategory = availableCategories.first(where: { $0.name == category })
            // 현재 카테고리 이름과 일치하는 카테고리 정보를 찾음
        let displayColor: Color
        if let matched = matchedCategory {
            displayColor = Color(hex: matched.color.hexCode)
        } else {
            displayColor = .gray
        }
            
        
        return AIInferenceResult(
            categoryId: matchedCategory?.id,
            category: category,
            categoryColor: displayColor,
            placeName: placeName.isEmpty ? nil : placeName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            duration: parsedTotalMinutes
        )
    }
    
    private let apiService = TodoAPIService.shared
    private var aiInferenceTask: Task<Void, Never>?
    
    // ✅ 날짜 미지정 시 플레이스홀더 텍스트 반환
    var formattedDate: String {
        guard let date = selectedDate else {
            return "- - - -, - -, - -"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    init(item: TodoItem) {
        self.title = item.title
        
        // ✅ [중요] item.date가 nil이면 selectedDate도 nil로 초기화 (자동으로 오늘 날짜 설정 금지)
        self.selectedDate = item.date
        
        self.placeName = item.placeName ?? ""
        self.address = item.address
        self.latitude = item.latitude
        self.longitude = item.longitude
        self.isLocationAIGenerated = (item.placeName == nil)
        
        self.duration = TodoEditViewModel.formatDuration(minutes: item.estimatedMinutes)
        self.isDurationAIGenerated = (item.estimatedMinutes == nil)
        
        self.category = item.category
        self.isCategoryAIGenerated = item.category.isEmpty
        
        self.relatedSchedules = item.relatedSchedules
        self.originalAISource = item.aiSource
        
        self.isRoutineEnabled = item.isRoutineEnabled
        self.selectedRoutine = item.routineType
        self.hasEndDate = item.routineEndDate != nil
        self.routineEndDate = item.routineEndDate
            ?? Calendar.current.date(byAdding: .month, value: 1, to: Date())
            ?? Date()
        
        self.isScheduleAIGenerated = true
        self.isFavoriteRecommendation = false
        
        parseDuration()
        
        var components = DateComponents()
        components.hour = selectedHour
        components.minute = selectedMinute
        self.durationDate = Calendar.current.date(from: components) ?? Date()
    }
    
    // MARK: - 제목 변경 시 AI 추론
    func onTitleChanged(_ newTitle: String) {
        guard newTitle != self.title else { return }
        
        self.title = newTitle
        guard !newTitle.isEmpty else { return }
        
        aiInferenceTask?.cancel()
        aiInferenceTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            if Task.isCancelled { return }
            
            await performAIInference(title: newTitle)
        }
    }
    
    @MainActor
    private func performAIInference(title: String) async {
        isInferringCategory = true
        do {
            let response = try await apiService.aiInference(title: title)
            let result = response.todoInfo.toAIInferenceResult()
            self.category = result.category
            
            if result.category != "미지정" {
                self.isCategoryAIGenerated = false
            }
        } catch {
            print("AI 추론 실패: \(error)")
        }
        isInferringCategory = false
    }
    
    @MainActor
    func loadMyPlaces() async {
        do {
            let places = try await apiService.getMyPlaces()
            self.myLocations = places.map { $0.toTodoMyLocation() }
        } catch {
            print("내장소 조회 실패: \(error)")
        }
    }
    
    @MainActor
    func selectPlace(name: String, address: String, latitude: Double, longitude: Double) async {
        self.placeName = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.isLocationAIGenerated = false
        
        self.isRecommendingSchedules = true
        
        let requestDTO = RecommendSchedulesRequestDTO(
            placeName: name, address: address, latitude: latitude, longitude: longitude
        )
        
        do {
            let response = try await apiService.recommendSchedules(body: requestDTO)
            let existingSelected = self.relatedSchedules.filter { $0.isSelected }
            let nearbySchedules = response.nearbyTodos.map { $0.toTodoRelatedScheduleItem() }
            let candidateSchedules = response.candidateTodos.map { $0.toTodoRelatedScheduleItem() }
            
            self.relatedSchedules = existingSelected + nearbySchedules + candidateSchedules
            self.isFavoriteRecommendation = response.isFavoriteRecommendation
            
            self.isScheduleAIGenerated = false
        } catch {
            print("일정 추천 조회 실패: \(error)")
        }
        self.isRecommendingSchedules = false
    }
    
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
    
    func loadCategories() async {
        do {
            // ✅ 서버에서 카테고리 목록 조회
            let categories = try await apiService.getCategories()
            await MainActor.run {
                self.availableCategories = categories
            }
        } catch {
            print("카테고리 목록 조회 실패: \(error)")
            // ✅ 실패 시 빈 배열
            await MainActor.run {
                self.availableCategories = []
            }
        }
    }
    
    func saveChanges(to item: inout TodoItem) {
        item.title = title
        item.date = selectedDate
        item.placeName = placeName
        item.address = address
        item.latitude = latitude
        item.longitude = longitude
        item.category = category
        
        // ✅ 카테고리 ID 및 **Color** 업데이트
        if let matchedCategory = availableCategories.first(where: { $0.name == category }) {
            item.categoryId = matchedCategory.id
            item.categoryColor = Color(hex: matchedCategory.color.hexCode)
            
            print("✅ 매칭된 카테고리: \(matchedCategory.name), ID: \(matchedCategory.id)")
        }else {
            item.categoryId = nil
            // 미지정이면 기본 회색
            item.categoryColor = CategoryHelper.color(for: "미지정")
            print("⚠️ 매칭되는 카테고리 없음 -> categoryId = nil")
        }
        
        item.estimatedMinutes = parsedTotalMinutes
        
        let selectedSchedules = relatedSchedules.filter { $0.isSelected }
        item.relatedSchedules = selectedSchedules
        item.linkedScheduleId = selectedSchedules.first?.scheduleId
        
        item.isRoutineEnabled = isRoutineEnabled
        item.routineType = selectedRoutine
        item.routineEndDate = hasEndDate ? routineEndDate : nil
    }
    
    private var parsedTotalMinutes: Int {
        return selectedHour * 60 + selectedMinute
    }
    
    static func formatDuration(minutes: Int?) -> String {
        guard let minutes = minutes, minutes > 0 else { return "1시간 10분" }
        let h = minutes / 60
        let m = minutes % 60
        if h > 0 && m > 0 { return "\(h)시간 \(m)분" }
        if h > 0 { return "\(h)시간" }
        return "\(m)분"
    }
}
