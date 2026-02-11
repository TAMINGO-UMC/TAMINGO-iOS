//
//  TodoCategoryService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
import Moya

protocol TodoCategoryServiceProtocol {
    func fetchCategories() async throws -> [TodoCategory]
    func createCategory(name: String, colorCode: String) async throws -> TodoCategory
    func updateCategory(id: Int, name: String, colorCode: String) async throws -> TodoCategory
    func deleteCategory(id: Int) async throws
}

final class TodoCategoryService: TodoCategoryServiceProtocol {
    
    private let provider = MoyaProvider<TodoCategoryAPI>(
        plugins: [
            NetworkLoggerPlugin(configuration: .init(
                logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
            ))
        ]
    )
    
    func fetchCategories() async throws -> [TodoCategory] {
        let response = try await request(.fetchCategories)

        let decoded = try JSONDecoder().decode(
            BaseResponse<[TodoCategoryResponseDTO]>.self,
            from: response.data
        )

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
        
        let response = try await request(.createCategory)
        
        let decoded = try JSONDecoder().decode(
            BaseResponse<TodoCategoryResponseDTO>.self,
            from: response.data
        )
        
        guard let result = decoded.result else {
            throw APIError.transport("응답 데이터가 없습니다.")
        }
        
        return result.toDomain()
    }

    
    func updateCategory(id: Int, name: String, colorCode: String) async throws -> TodoCategory {

        let response = try await request(.updateCategory(id: id))
        
        let decoded = try JSONDecoder().decode(
            BaseResponse<TodoCategoryResponseDTO>.self,
            from: response.data
        )
        
        guard let result = decoded.result else {
            throw APIError.transport("응답 데이터가 없습니다.")
        }
        
        return result.toDomain()
    }

    
    func deleteCategory(id: Int) async throws {
        _ = try await request(.deleteCategory(id: id))
    }
    
    
}

private extension TodoCategoryService {

    func request(_ target: TodoCategoryAPI) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):

                    if (200..<300).contains(response.statusCode) {
                        continuation.resume(returning: response)
                    } else {

                        if let apiErrorDTO = try? JSONDecoder().decode(
                            CategoryAPIErrorResponseDTO.self,
                            from: response.data
                        ) {
                            continuation.resume(
                                throwing: APIError.server(
                                    status: response.statusCode,
                                    message: apiErrorDTO.message
                                )
                            )
                        } else {
                            continuation.resume(
                                throwing: APIError.transport(
                                    "서버 오류 (\(response.statusCode))"
                                )
                            )
                        }
                    }


                case .failure(let error):
                    if let response = error.response,
                       let apiErrorDTO = try? JSONDecoder().decode(
                        CategoryAPIErrorResponseDTO.self,
                            from: response.data
                       ) {
                        continuation.resume(
                            throwing: APIError.server(
                                status: response.statusCode,
                                message: apiErrorDTO.message
                            )
                        )
                    }
                    else {
                        continuation.resume(
                            throwing: APIError.transport(
                                error.localizedDescription
                            )
                        )
                    }
                }
            }
        }
    }


    func decodePlaceId(from response: Response) throws -> Int {
        try JSONDecoder()
            .decode(PlaceIdResponseDTO.self, from: response.data)
            .placeId
    }
}
