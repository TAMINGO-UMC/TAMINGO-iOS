//
//  AddScheduleViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 1/23/26.
//

import SwiftUI
import Combine

@Observable
class AddScheduleViewModel {
    // UI 바인딩 변수들
    var titleInput: String = "" {
        didSet {
            // Observable 매크로에서는 didSet으로 Combine 연결이 까다로울 수 있어,
            // View의 .onChange 혹은 별도 Subject로 이벤트를 전달합니다.
            inputSubject.send(titleInput)
        }
    }
    
    var place: String = ""
    var category: ScheduleCategory = .school
    var startTime: Date = Date()
    var endTime: Date = Date().addingTimeInterval(3600)
    
    var isAnalyzing: Bool = false // AI 분석중 로딩
    var isSaving: Bool = false    // 저장중 로딩
    
    // Combine
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<String, Never>() // 입력을 받을 통로
    
    // 서비스 주입
    private let service: ScheduleServiceProtocol
    
    init(service: ScheduleServiceProtocol = MockScheduleService()) {
        self.service = service
        setupCombine()
    }
    
    private func setupCombine() {
        inputSubject
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main) // 1초 동안 입력 없으면
            .removeDuplicates()                                    // 같은 내용이면 무시
            .filter { !$0.isEmpty }                                // 빈 문자열 제외
            .sink { [weak self] text in
                self?.triggerAIAnalysis(text: text)                // AI 호출
            }
            .store(in: &cancellables)
    }
    
    // AI 분석 요청
    @MainActor
    private func triggerAIAnalysis(text: String) {
        self.isAnalyzing = true
        
        Task {
            do {
                let result = try await service.analyzeText(text)
                
                // 결과 UI 반영
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
    
    // 최종 저장 요청
    @MainActor
    func saveSchedule(completion: @escaping () -> Void) {
        self.isSaving = true
        
        Task {
            let request = ScheduleSaveRequest(
                title: titleInput,
                place: place,
                category: category.rawValue, // "SCHOOL"
                startTime: startTime.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
                endTime: endTime.toString(format: "yyyy-MM-dd'T'HH:mm:ss")
            )
            
            do {
                let success = try await service.saveSchedule(request)
                if success {
                    completion() // 화면 닫기 등 후처리
                }
            } catch {
                print("저장 실패")
            }
            self.isSaving = false
        }
    }
}
