//
//  AddScheduleViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 1/31/26.
//

import SwiftUI
import Observation
import Combine
import Moya

@Observable
class AddScheduleViewModel {
    // MARK: - Dependencies
    let provider = MoyaProvider<ScheduleTarget>(
        stubClosure: MoyaProvider.delayedStub(1.0),
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
    )
    var cancellables = Set<AnyCancellable>()
    let inputSubject = PassthroughSubject<String, Never>()
    
    // MARK: - State Properties
    var isLoading: Bool = false
    var isEditing: Bool = false
    var isTodoExpanded: Bool = false
    
    var categories: [ScheduleCategoryDTO] = []
    var myPlaces: [MyPlaceDTO] = []
    
    // MARK: - Input Properties
    var title: String = "" {
        didSet { inputSubject.send(title) }
    }
    
    var scheduleDate: Date = Date()
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
    var repeatType: RepeatType = .none
    var repeatEndDate: Date = Date()
    
    // MARK: - AI Inference Properties
    var placeName: String = ""
    var address: String = ""
    var latitude: Double?
    var longitude: Double?
    
    var scheduleCategoryId: Int = 0
    var categoryName: String = ""
    
    var nearbyTodos: [TodoSummaryDTO] = []
    var candidateTodos: [TodoSummaryDTO] = []
    var linkedTodoIds: [Int] = []
    
    var isFavoriteRecommendation: Bool = false
    var aiInferenceSource = AIInferenceSource(aiSuggestedPlaceName: "", aiSuggestedCategoryName: "")
    
    // MARK: - Initializer
    init() {
        bindInputs()
        loadCategories()
        loadFavoritePlaces()
    }
    
    // MARK: - Binding Logic
    func bindInputs() {
        // 1. [즉시 반응] 입력 감지 시 로딩 ON
        inputSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] query in
                guard let self = self else { return }
                
                if !query.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.isLoading = true
                } else {
                    self.isLoading = false
                    self.resetInferredData()
                }
            }
            .store(in: &cancellables)
        
        // 2. [지연 반응] API 호출
        inputSubject
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                
                if !query.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.performAIInference(query: query)
                }
            }
            .store(in: &cancellables)
    }
}
