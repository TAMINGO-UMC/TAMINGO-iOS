//
//  TodoAPIService.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/5/26.
//


import Foundation
import Moya

class TodoAPIService {
    static let shared = TodoAPIService()
    
    private let provider = MoyaProvider<TodoTarget>()
    
    private init() {}
    
    // MARK: - 1. 내장소 가져오기 (GET)
    func getMyPlaces() async throws -> [MyPlaceDTO] {
        let response: BaseResponse<[MyPlaceDTO]> = try await provider.request(.getMyPlaces)
        
        guard response.isSuccess, let result = response.result else {
            throw APIError.server(status: 400, message: response.message)
        }
        
        return result
    }
    
    // MARK: - 2. 할 일 생성 (POST)
    func createTodo(body: TodoCreateRequestDTO) async throws -> TodoCreateResponseDTO {
        let response: BaseResponse<TodoCreateResponseDTO> = try await provider.request(.createTodo(body: body))
        
        guard response.isSuccess, let result = response.result else {
            throw APIError.server(status: 400, message: response.message)
        }
        
        return result
    }
    
    // MARK: - 3. 할 일 수정 (PUT)
    func updateTodo(id: Int, body: TodoUpdateRequestDTO) async throws -> String {
        let response: BaseResponse<String> = try await provider.request(.updateTodo(id: id, body: body))
        
        guard response.isSuccess, let result = response.result else {
            throw APIError.server(status: 400, message: response.message)
        }
        
        return result
    }
    
    // MARK: - 4. AI 추론 (POST)
    func getAIInference(title: String) async throws -> AIInferenceResponseDTO {
        let response: BaseResponse<AIInferenceResponseDTO> = try await provider.request(.aiInference(title: title))
        
        guard response.isSuccess, let result = response.result else {
            throw APIError.server(status: 400, message: response.message)
        }
        
        return result
    }
    
    // MARK: - 5. 자주 가는 장소 목록 조회 (GET)
    func getFrequentPlaces() async throws -> [FrequentPlaceDTO] {
        let response: BaseResponse<FrequentPlacesResponseDTO> = try await provider.request(.getFrequentPlaces)
        
        guard response.isSuccess, let result = response.result else {
            throw APIError.server(status: 400, message: response.message)
        }
        
        return result.places
    }
    
    // MARK: - 6. 장소 선택 시 관련 할일 조회 (POST)
    func getRelatedTodos(body: RelatedTodosRequestDTO) async throws -> RelatedTodosResponseDTO {
        let response: BaseResponse<RelatedTodosResponseDTO> = try await provider.request(.getRelatedTodos(body: body))
        
        guard response.isSuccess, let result = response.result else {
            throw APIError.server(status: 400, message: response.message)
        }
        
        return result
    }
    
    // MARK: - 7. 할일 상세 조회 (GET)
    func getTodoDetail(id: Int) async throws -> TodoDetailResponseDTO {
        let response: BaseResponse<TodoDetailResponseDTO> = try await provider.request(.getTodoDetail(id: id))
        
        guard response.isSuccess, let result = response.result else {
            throw APIError.server(status: 400, message: response.message)
        }
        
        return result
    }
    
    // MARK: - 8. 할일 완료 체크 (PUT)
    func updateTodoCompletion(id: Int, isChecked: Bool) async throws -> String {
        let body = TodoCompletionRequestDTO(isChecked: isChecked)
        let response: BaseResponse<String> = try await provider.request(.updateTodoCompletion(id: id, body: body))
        
        guard response.isSuccess, let result = response.result else {
            throw APIError.server(status: 400, message: response.message)
        }
        
        return result
    }
}
