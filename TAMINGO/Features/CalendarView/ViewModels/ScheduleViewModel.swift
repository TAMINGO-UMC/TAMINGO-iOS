//
//  ScheduleViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 1/18/26.
//

import SwiftUI
import Observation
import Combine

@Observable
class ScheduleViewModel {
    var allSchedules: [ScheduleItem] = []
    
    var titleInput: String = "" {
        didSet { inputSubject.send(titleInput) }
    }
    var place: String = ""
    var startTime: Date = Date()
    var endTime: Date = Date().addingTimeInterval(3600)
    var category: ScheduleCategory = .none
    var repeatType: RepeatType = .none
    var repeatEndDate: Date? = nil
    var memo: String = ""
    var relatedTodoIds: [Int] = []
    
    // 상태 변수
    var isAnalyzing: Bool = false
    var isSaving: Bool = false
    
    private let service: ScheduleServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<String, Never>()

    init(service: ScheduleServiceProtocol = MockScheduleService()) {
        self.service = service
        self.allSchedules = []
        setupAIAnalyze()
    }
    
    // MARK: - AI 추론 로직 (Combine)
    private func setupAIAnalyze() {
        inputSubject
            .debounce(for: .seconds(1.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] text in
                self?.analyzeTitleWithAI(text)
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func analyzeTitleWithAI(_ text: String) {
        Task {
            self.isAnalyzing = true
            do {
                let result = try await service.analyzeText(text)
                withAnimation {
                    self.place = result.place
                    self.category = ScheduleCategory(rawValue: result.category) ?? .none
                    self.startTime = result.startDateTime
                    self.endTime = result.endDateTime
                }
            } catch {
                print("AI 분석 실패: \(error)")
            }
            self.isAnalyzing = false
        }
    }

    // MARK: - 저장 로직
    @MainActor
    func saveSchedule() async {
        self.isSaving = true
        
        let request = ScheduleSaveRequest(
            title: titleInput,
            startTime: startTime.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
            endTime: endTime.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
            placeName: place,
            latitude: "", // 필요한 경우 추가
            longitude: "",
            category: category.rawValue,
            repeatType: repeatType.rawValue,
            repeatEndDate: repeatEndDate?.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
            memo: memo,
            relatedTodoIds: relatedTodoIds
        )
        
        do {
            let success = try await service.saveSchedule(request)
            if success {
                let newId = (allSchedules.map { $0.id }.max() ?? 0) + 1
                let newItem = ScheduleItem(
                    id: newId,
                    title: titleInput,
                    place: place,
                    category: category,
                    startDateTime: startTime,
                    endDateTime: endTime,
                    memo: memo
                )
                allSchedules.append(newItem)
                resetInputs()
            }
        } catch {
            print("저장 실패: \(error)")
        }
        self.isSaving = false
    }
    
    private func resetInputs() {
        titleInput = ""
        place = ""
        category = .none
        startTime = Date()
        endTime = Date().addingTimeInterval(3600)
        memo = ""
    }
    
    func getSchedules(for date: Date) -> [ScheduleItem] {
        return allSchedules.filter { Calendar.current.isDate($0.startDateTime, inSameDayAs: date) }
    }
}
