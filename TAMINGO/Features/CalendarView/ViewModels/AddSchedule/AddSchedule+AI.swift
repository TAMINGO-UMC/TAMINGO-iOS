//
//  AddSchedule+AI.swift
//  TAMINGO
//
//  Created by 김도연 on 1/31/26.
//

import Foundation
import Moya

extension AddScheduleViewModel {
    
    // MARK: - Network: AI Inference
    func performAIInference(query: String) {
        self.isLoading = true
        
        provider.request(.aiInference(title: query)) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decodedData = try filteredResponse.map(BaseResponse<AIInferenceResponseDTO>.self)
                    
                    if let resultData = decodedData.result {
                        self.applyInferenceResult(resultData)
                    }
                } catch {
                    print("AI Inference Parsing Error: \(error)")
                }
            case .failure(let error):
                print("AI Inference Network Error: \(error)")
            }
        }
    }
    
    // MARK: - AI Helpers
    func applyInferenceResult(_ data: AIInferenceResponseDTO) {
        // 장소 매핑
        self.placeName = data.aiInference.placeName
        self.address = data.aiInference.address
        self.latitude = data.aiInference.latitude
        self.longitude = data.aiInference.longitude
        self.categoryName = data.aiInference.category
        
        // 출처 기록
        self.aiInferenceSource.aiSuggestedPlaceName = data.aiInference.placeName
        self.aiInferenceSource.aiSuggestedCategoryName = data.aiInference.category
        
        // 카테고리 매칭
        self.scheduleCategoryId = findCategoryId(by: data.aiInference.category) ?? 0
        
        // 할 일 리스트 매핑
        self.linkedTodos = data.nearbyTodos
        self.candidateTodos = data.candidateTodos
        
        // UI 상태 업데이트
        self.isFavoriteRecommendation = data.isFavoriteRecommendation
        
        print("AI 추론 완료: \(self.placeName), 선택된 할 일 개수: \(self.linkedTodos.count)")
    }
    
    func resetInferredData() {
        self.placeName = ""
        self.address = ""
        self.latitude = nil
        self.longitude = nil
        self.categoryName = "카테고리 없음"
        
        // 투두 리셋
        self.linkedTodos = []
        self.candidateTodos = []
        self.isFavoriteRecommendation = false
    }
}
