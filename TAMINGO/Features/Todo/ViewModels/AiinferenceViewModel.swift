import Foundation
import Combine

enum AIInferenceState {
    case idle
    case loading
    case success(AIInferenceResult)
    case error(String)
}

class AIInferenceViewModel: ObservableObject {
    @Published var state: AIInferenceState = .idle
    
    private let apiService = TodoAPIService.shared
    
    /// API를 통한 실제 AI 추론 요청 (async/await 방식)
    func fetchAIInference(for todoTitle: String) {
        // 빈 제목이면 추론하지 않음
        guard !todoTitle.isEmpty else {
            state = .idle
            return
        }
        
        // 로딩 상태로 변경
        state = .loading
        
        Task {
            do {
                let response = try await apiService.aiInference(title: todoTitle)
                let inferenceResult = response.todoInfo.toAIInferenceResult()
                
                await MainActor.run {
                    self.state = .success(inferenceResult)
                }
            } catch {
                await MainActor.run {
                    print("AI Inference Error: \(error)")
                    self.state = .error("AI 추론 중 오류가 발생했습니다.")
                }
            }
        }
    }
    
    // 상태 초기화
    func reset() {
        state = .idle
    }
}
