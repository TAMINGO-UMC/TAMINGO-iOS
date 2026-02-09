//
//  TodoAPIService.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: Test Mode (Stub) 적용 - deleteTodo 추가
//

import Foundation
import Moya

class TodoAPIService {
    static let shared = TodoAPIService()
    
    private let provider: MoyaProvider<TodoTarget>
    private let decoder = JSONDecoder()
    
    private init() {
        let logger = NetworkLoggerPlugin(configuration: .init(logOptions: [.verbose]))
        
        // MARK: - ⚠️ 테스트 모드 (Stub 활성화)
        self.provider = MoyaProvider<TodoTarget>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [logger]
        )
        // self.provider = MoyaProvider<TodoTarget>(plugins: [logger])
    }
    
    // MARK: - 1. 내장소 가져오기
    func getMyPlaces() async throws -> [MyPlacesDTO] {
        let response = try await provider.requestAsync(.getMyPlaces)
        return try decodeOrThrow(response, as: [MyPlacesDTO].self)
    }
    
    // MARK: - 2. 할 일 생성
    func createTodo(body: TodoCreateRequestDTO) async throws -> TodoCreateResponseDTO {
        let response = try await provider.requestAsync(.createTodo(body: body))
        return try decodeOrThrow(response, as: TodoCreateResponseDTO.self)
    }
    
    // MARK: - 3. 할 일 수정
    func updateTodo(id: Int, body: TodoUpdateRequestDTO) async throws {
        let response = try await provider.requestAsync(.updateTodo(id: id, body: body))
        _ = try decodeOrThrow(response, as: String.self)
    }
    
    // MARK: - 4. AI 추론
    func aiInference(title: String) async throws -> TodoAIInferenceResponseDTO {
        let response = try await provider.requestAsync(.aiInference(title: title))
        return try decodeOrThrow(response, as: TodoAIInferenceResponseDTO.self)
    }
    
    // MARK: - 5. 장소 수정 시 일정 추천 (NEW)
    func recommendSchedules(body: RecommendSchedulesRequestDTO) async throws -> RecommendSchedulesResponseDTO {
        let response = try await provider.requestAsync(.recommendSchedules(body: body))
        return try decodeOrThrow(response, as: RecommendSchedulesResponseDTO.self)
    }
    
    // MARK: - 6. 할일 목록 조회
    func getTodoList(date: String) async throws -> TodoListResponseDTO {
        let response = try await provider.requestAsync(.getTodoList(date: date))
        return try decodeOrThrow(response, as: TodoListResponseDTO.self)
    }
    
    // MARK: - 7. 할일 상세 조회
    func getTodoDetail(id: Int) async throws -> TodoDetailResponseDTO {
        let response = try await provider.requestAsync(.getTodoDetail(id: id))
        return try decodeOrThrow(response, as: TodoDetailResponseDTO.self)
    }
    
    // MARK: - 8. 할일 완료 체크
    func updateTodoCompletion(id: Int, isChecked: Bool) async throws {
        let body = TodoCompletionRequestDTO(isChecked: isChecked)
        let response = try await provider.requestAsync(.updateTodoCompletion(id: id, body: body))
        _ = try decodeOrThrow(response, as: String.self)
    }
    
    // MARK: - 9. 할일 삭제
    func deleteTodo(id: Int) async throws {
        let response = try await provider.requestAsync(.deleteTodo(id: id))
        _ = try decodeOrThrow(response, as: String.self)
    }
    
    // MARK: - Decode Helper
    private func decodeOrThrow<T: Decodable>(_ response: Response, as type: T.Type) throws -> T {
        if (200..<300).contains(response.statusCode) {
            do {
                let baseResponse = try decoder.decode(BaseResponse<T>.self, from: response.data)
                guard let result = baseResponse.result else {
                    throw APIError.server(status: response.statusCode, message: "서버 응답 결과(result)가 비어있습니다.")
                }
                return result
            } catch {
                if let apiError = error as? APIError { throw apiError }
                print("Decoding Error: \(error)")
                throw APIError.transport("디코딩 실패: \(error.localizedDescription)")
            }
        } else {
            let errorBody = String(data: response.data, encoding: .utf8) ?? "알 수 없는 데이터"
            print("[TodoAPIService] 서버 에러 응답 Body: \(errorBody)")
            
            if let errorResponse = try? decoder.decode(APIErrorResponseDTO.self, from: response.data) {
                throw APIError.server(status: errorResponse.status, message: errorResponse.message)
            } else {
                throw APIError.server(status: response.statusCode, message: "서버 오류: \(errorBody)")
            }
        }
    }
}
