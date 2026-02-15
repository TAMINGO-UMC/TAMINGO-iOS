import Foundation
import Combine
import SwiftUI

enum AIInferenceState {
    case idle
    case loading
    case success(AIInferenceResult)
    case error(String)
}

class AIInferenceViewModel: ObservableObject {
    @Published var state: AIInferenceState = .idle
    
    private let apiService = TodoAPIService.shared
    private var categoryById: [Int: TodoCategory] = [:]
    private var categoryByName: [String: TodoCategory] = [:]
    
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
                var inferenceResult = response.todoInfo.toAIInferenceResult()
                
                // TodoRow와 동일 규칙으로 카테고리 색상 보정
                if inferenceResult.categoryColor == nil {
                    await loadCategoriesIfNeeded()
                    
                    if let categoryId = inferenceResult.categoryId,
                       let category = categoryById[categoryId] {
                        inferenceResult = AIInferenceResult(
                            categoryId: inferenceResult.categoryId,
                            category: inferenceResult.category,
                            categoryColor: Color(hex: category.color.hexCode),
                            placeName: inferenceResult.placeName,
                            address: inferenceResult.address,
                            latitude: inferenceResult.latitude,
                            longitude: inferenceResult.longitude,
                            duration: inferenceResult.duration
                        )
                    } else if let category = categoryByName[inferenceResult.category] {
                        inferenceResult = AIInferenceResult(
                            categoryId: inferenceResult.categoryId,
                            category: inferenceResult.category,
                            categoryColor: Color(hex: category.color.hexCode),
                            placeName: inferenceResult.placeName,
                            address: inferenceResult.address,
                            latitude: inferenceResult.latitude,
                            longitude: inferenceResult.longitude,
                            duration: inferenceResult.duration
                        )
                    } else {
                        inferenceResult = AIInferenceResult(
                            categoryId: inferenceResult.categoryId,
                            category: inferenceResult.category,
                            categoryColor: CategoryHelper.color(for: inferenceResult.category),
                            placeName: inferenceResult.placeName,
                            address: inferenceResult.address,
                            latitude: inferenceResult.latitude,
                            longitude: inferenceResult.longitude,
                            duration: inferenceResult.duration
                        )
                    }
                }
                
                let resolvedResult = inferenceResult
                await MainActor.run {
                    self.state = .success(resolvedResult)
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
    
    private func loadCategoriesIfNeeded() async {
        guard categoryById.isEmpty else { return }
        
        do {
            let categories = try await apiService.getCategories()
            categoryById = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
            categoryByName = Dictionary(uniqueKeysWithValues: categories.map { ($0.name, $0) })
        } catch {
            // 색상 fallback은 CategoryHelper 사용
        }
    }
}
