//
//  TodoCategoryService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
import Moya
import Alamofire

protocol TodoCategoryServiceProtocol {
    func fetchCategories() async throws -> [TodoCategory]
    func createCategory(name: String, colorCode: String) async throws -> TodoCategory
    func updateCategory(id: Int, name: String, colorCode: String) async throws -> TodoCategory
    func deleteCategory(id: Int) async throws
}

final class TodoCategoryService: TodoCategoryServiceProtocol {
    
    // [수정 2] Interceptor가 포함된 Session 생성
    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    // [수정 3] provider 변수 선언 (init에서 초기화)
    private let provider: MoyaProvider<TodoCategoryAPI>
    
    // [수정 4] 초기화 메서드 추가 및 Session 주입
    init() {
        self.provider = MoyaProvider<TodoCategoryAPI>(
            session: session, // 핵심: 여기에 interceptor가 담긴 session을 전달해야 갱신 로직이 동작함
            plugins: [
                NetworkLoggerPlugin(configuration: .init(
                    logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
                ))
            ]
        )
    }
    func fetchCategories() async throws -> [TodoCategory] {
        let response = try await provider.requestAsync(.fetchCategories)

        let decoded = try JSONDecoder().decode(
            BaseResponse<[TodoCategoryResponseDTO]>.self,
            from: response.data
        )
        
        guard decoded.isSuccess else {
            throw APIError.server(
                status: response.statusCode,
                message: decoded.message
            )
        }

        guard let result = decoded.result else {
            return []
        }

        return result.map { $0.toDomain() }

    }
    
    func createCategory(name: String, colorCode: String) async throws -> TodoCategory {
        let requestDTO = TodoCategoryRequestDTO(
            name: name,
            colorCode: colorCode
        )

        let response = try await provider.requestAsync(
            .createCategory(request: requestDTO)
        )
        
        let decoded = try JSONDecoder().decode(
            BaseResponse<TodoCategoryResponseDTO>.self,
            from: response.data
        )
        
        guard decoded.isSuccess else {
            throw APIError.server(
                status: response.statusCode,
                message: decoded.message
            )
        }
        
        guard let result = decoded.result else {
            throw APIError.transport("응답 데이터가 없습니다.")
        }
        
        return result.toDomain()
    }

    
    func updateCategory(id: Int, name: String, colorCode: String) async throws -> TodoCategory {

        let requestDTO = TodoCategoryRequestDTO(
            name: name,
            colorCode: colorCode
        )

        let response = try await provider.requestAsync(
            .updateCategory(id: id, request: requestDTO)
        )
        
        let decoded = try JSONDecoder().decode(
            BaseResponse<TodoCategoryResponseDTO>.self,
            from: response.data
        )
        
        guard decoded.isSuccess else {
            throw APIError.server(
                status: response.statusCode,
                message: decoded.message
            )
        }
        
        guard let result = decoded.result else {
            throw APIError.transport("응답 데이터가 없습니다.")
        }
        
        return result.toDomain()
    }

    
    func deleteCategory(id: Int) async throws {
        let response = try await provider.requestAsync(.deleteCategory(id: id))

        let decoded = try JSONDecoder().decode(
            BaseResponse<EmptyResponse>.self,
            from: response.data
        )

        guard decoded.isSuccess else {
            throw APIError.server(
                status: response.statusCode,
                message: decoded.message
            )
        }
    }

    
}

