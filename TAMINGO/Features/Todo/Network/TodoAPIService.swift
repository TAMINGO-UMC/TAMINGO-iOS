//
//  TodoAPIService.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: TokenInterceptor 연결 및 Alamofire Session 적용
//

import Foundation
import Moya
import Alamofire

class TodoAPIService {
    static let shared = TodoAPIService()
    
    private let provider: MoyaProvider<TodoTarget>
    private let decoder = JSONDecoder()
    
    private init() {
        let logger = NetworkLoggerPlugin(configuration: .init(logOptions: [.verbose]))
        
        // Interceptor를 포함한 Session 생성
        // TokenInterceptor가 요청 전 토큰 주입(adapt) 및 401 에러 시 갱신(retry)을 담당
        let session = Session(interceptor: TokenInterceptor())
        
        // MARK: - 실제 서버 연결 (Stub 비활성화)
        // 생성한 session을 Provider에 주입합니다.
        self.provider = MoyaProvider<TodoTarget>(
            session: session,
            plugins: [logger]
        )
        
        // MARK: - 테스트 모드 (Stub 활성화) - 테스트 시에만 사용
        // self.provider = MoyaProvider<TodoTarget>(
        //     stubClosure: MoyaProvider.immediatelyStub,
        //     session: session, // Stub 모드에서도 인터셉터 동작을 테스트하려면 session 주입 필요
        //     plugins: [logger]
        // )
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
    func updateTodo(id: Int, body: TodoUpdateRequestDTO) async throws -> TodoUpdateResponseDTO {
        let response = try await provider.requestAsync(.updateTodo(id: id, body: body))
        return try decodeOrThrow(response, as: TodoUpdateResponseDTO.self)
    }
    
    // MARK: - 4. AI 추론
    func aiInference(title: String) async throws -> TodoAIInferenceResponseDTO {
        let response = try await provider.requestAsync(.aiInference(title: title))
        return try decodeOrThrow(response, as: TodoAIInferenceResponseDTO.self)
    }
    
    // MARK: - 5. 장소 수정 시 일정 추천
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
    
    // MARK: - 10. 카테고리 목록 조회
    func getCategories() async throws -> [TodoCategory] {
        let response = try await provider.requestAsync(.getCategories)
        let dtos = try decodeOrThrow(response, as: [CategoryResponseDTO].self)
        return dtos.map { $0.toDomain() }
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
                // Interceptor가 재시도(Retry)를 했음에도 실패하면 이쪽으로.
                throw APIError.server(status: errorResponse.status, message: errorResponse.message)
            } else {
                throw APIError.server(status: response.statusCode, message: "서버 오류: \(errorBody)")
            }
        }
    }
}
