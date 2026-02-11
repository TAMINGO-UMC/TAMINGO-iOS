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
@MainActor
class AddScheduleViewModel {
    // MARK: - Dependencies
    let provider = MoyaProvider<ScheduleTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    var cancellables = Set<AnyCancellable>()
    let inputSubject = PassthroughSubject<String, Never>()
    
    // MARK: - State Properties
    var isLoading: Bool = false
    var isTodoExpanded: Bool = false
    
    var categories: [ScheduleCategoryDTO] = []
    var myPlaces: [MyPlaceDTO] = []
    
    // MARK: - Input Properties
    var title: String = "" {
        didSet {
            if title != oldValue {
                inputSubject.send(title)
            }
        }
    }
    
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
    
    // MARK: - Repeat Logic (Updated)
    var repeatType: RepeatType = .none {
        didSet {
            // 반복 설정이 켜질 때, 종료 날짜 토글이 꺼져있다면 자동으로 켜줌 (사용자 편의)
            if repeatType != .none && !isEndDated {
                isEndDated = true
            }
        }
    }
    
    // View와 바인딩될 종료 날짜 토글 상태
    var isEndDated: Bool = true {
        didSet {
            // 토글을 켜면 날짜를 오늘로 리셋 (혹은 기존 날짜 유지)
            if isEndDated {
                let calendar = Calendar.current
                self.repeatEndDate = Date()
            }
        }
    }
    
    // 실제 종료 날짜 값
    var repeatEndDate: Date = Date()
    
    // MARK: - AI Inference Properties
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
    
    // MARK: - Initializer
    init() {
        bindInputs()
        loadCategories()
        loadFavoritePlaces()
    }
    
    // MARK: - Binding Logic
    func bindInputs() {
        inputSubject
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.isLoading = true
                } else {
                    self?.isLoading = false
                    self?.resetInferredData()
                }
            }
            .store(in: &cancellables)
        
        inputSubject
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] text in
                self?.performAIInference(query: text)
            }
            .store(in: &cancellables)
    }
}
