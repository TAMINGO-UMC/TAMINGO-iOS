
import Foundation
import Combine
import Moya

enum AIInferenceState {
    case idle
    case loading
    case success(AIInferenceResult)
    case error(String)
}

class AIInferenceViewModel: ObservableObject {
    @Published var state: AIInferenceState = .idle
    
    private let provider = MoyaProvider<TodoTarget>(
        stubClosure: MoyaProvider.delayedStub(0.5),
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
    )
    
    /// API를 통한 실제 AI 추론 요청 (Moya Provider 방식)
    func fetchAIInference(for todoTitle: String) {
        // 빈 제목이면 추론하지 않음
        guard !todoTitle.isEmpty else {
            state = .idle
            return
        }
        
        // 로딩 상태로 변경
        state = .loading
        
        // Moya Provider 방식으로 API 호출
        provider.request(.aiInference(title: todoTitle)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    // 성공 상태 코드 필터링
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    
                    // BaseResponse 형식으로 디코딩
                    let decodedData = try filteredResponse.map(BaseResponse<TodoAIInferenceResponseDTO>.self)
                    
                    if let resultData = decodedData.result {
                        let inferenceResult = resultData.todoInfo.toAIInferenceResult()
                        self.state = .success(inferenceResult)
                    } else {
                        self.state = .error("AI 추론 결과가 없습니다.")
                    }
                } catch {
                    print("AI Inference Parsing Error: \(error)")
                    self.state = .error("AI 추론 결과를 처리하는 중 오류가 발생했습니다.")
                }
                
            case .failure(let error):
                print("AI Inference Network Error: \(error)")
                self.state = .error("네트워크 오류가 발생했습니다.")
            }
        }
    }
    
    // 상태 초기화
    func reset() {
        state = .idle
    }
}

