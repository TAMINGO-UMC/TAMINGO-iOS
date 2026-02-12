//
//  EditScheduleViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 2/1/26.
//

import SwiftUI
import Observation
import Combine
import Moya

@Observable
@MainActor
class EditScheduleViewModel {
    // MARK: - Dependencies
    let provider = MoyaProvider<ScheduleTarget>()
    
    var cancellables = Set<AnyCancellable>()
    let inputSubject = PassthroughSubject<String, Never>()
    
    // MARK: - State Properties
    var isLoading: Bool = false
    var isTodoExpanded: Bool = false
    
    var categories: [ScheduleCategoryDTO] = []
    var myPlaces: [MyPlaceDTO] = []
    
    var scheduleId: Int = 0
    // MARK: - Input Properties
    var title: String = ""
    
    var startTime: Date = Date() {
        didSet {
            if endTime <= startTime {
                endTime = startTime.addingTimeInterval(3600)
            }
        }
    }
    var endTime: Date = Date().addingTimeInterval(3600)
    
    var isTimeValid: Bool {
        let calendar = Calendar.current
        
        let startComp = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComp = calendar.dateComponents([.hour, .minute], from: endTime)
        
        let startTotalMinutes = (startComp.hour ?? 0) * 60 + (startComp.minute ?? 0)
        let endTotalMinutes = (endComp.hour ?? 0) * 60 + (endComp.minute ?? 0)
        
        return endTotalMinutes > startTotalMinutes
    }
    
    var memo: String = ""
    
    var repeatType: RepeatType = .none {
        didSet {
            if repeatType != .none && !isEndDated {
                isEndDated = true
            }
        }
    }
    var isEndDated: Bool = false
    var repeatEndDate: Date = Date()
    
    var placeName: String = ""
    var address: String = ""
    var latitude: Double?
    var longitude: Double?
    
    var scheduleCategoryId: Int = 0
    var categoryName: String = ""
    
    var linkedTodos: [TodoSummaryDTO] = []
    var candidateTodos: [TodoSummaryDTO] = []
    
    var isFavoriteRecommendation: Bool = false
    var aiInferenceSource = AIInferenceSource(aiSuggestedPlaceName: "", aiSuggestedCategoryName: "")
    
    init() {
        loadPlaces()
        loadCategories()
    }
}
