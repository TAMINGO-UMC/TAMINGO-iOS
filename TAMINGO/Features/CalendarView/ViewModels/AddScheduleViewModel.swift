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
        didSet {
            // 이전 값과 다를 때만 이벤트를 방출하여 불필요한 로딩 방지
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
        // 1. [즉시 실행] 사용자가 타이핑을 시작하자마자 로딩 상태를 true로 변경
        inputSubject
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.isLoading = true
                } else {
                    // 만약 글자를 다 지우면 로딩도 끄고 데이터도 초기화
                    self?.isLoading = false
                    self?.resetInferredData()
                }
            }
            .store(in: &cancellables)
        
        // 2. [지연 실행] 1초간 입력이 없을 때만 실제 AI API 호출
        inputSubject
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] text in
                // 여기서 performAIInference가 실행되며,
                // 내부의 Moya closure에서 마지막에 isLoading = false가 호출됩니다.
                self?.performAIInference(query: text)
            }
            .store(in: &cancellables)
    }
    
    func updateRepeatEndDate(isEnabled: Bool) {
        if isEnabled {
            // 활성화 시: 오늘 날짜로 초기화
            self.repeatEndDate = Date()
        } else {
            // 비활성화 시: 먼 미래로 설정
            let components = DateComponents(year: 2999, month: 12, day: 31)
            if let farFuture = Calendar.current.date(from: components) {
                self.repeatEndDate = farFuture
            }
        }
    }
}
