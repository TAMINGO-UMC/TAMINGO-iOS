//
//  AIInferenceViewModel.swift
//  TAMINGO
//
//  Created by Claude on 2/2/26.
//

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
    
    // 서버 응답 시뮬레이션 (실제로는 네트워크 요청으로 대체)
    func fetchAIInference(for todoTitle: String) {
        // 빈 제목이면 추론하지 않음
        guard !todoTitle.isEmpty else {
            state = .idle
            return
        }
        
        // 로딩 상태로 변경
        state = .loading
        
        // 임의의 서버 응답 시간 시뮬레이션 (1.5초)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            // 임시 더미 데이터 (실제로는 서버 응답 데이터 사용)
            let result = AIInferenceResult(
                category: "일상",
                location: "광운대학교 중앙도서관",
                estimatedTime: "10분"
            )
            
            self?.state = .success(result)
        }
    }
    
    // 상태 초기화
    func reset() {
        state = .idle
    }
}
