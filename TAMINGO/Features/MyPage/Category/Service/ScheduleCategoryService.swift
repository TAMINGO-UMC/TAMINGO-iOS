//
//  ScheduleCategoryService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
import Moya

protocol ScheduleCategoryServiceProtocol {
    func fetchCategories() async throws -> [ScheduleCategory]
    func createCategory(name: String, colorCode: String) async throws -> ScheduleCategory
    func updateCategory(id: Int, name: String, colorCode: String) async throws -> ScheduleCategory
    func deleteCategory(id: Int) async throws
}

final class ScheduleCategoryService: ScheduleCategoryServiceProtocol {
    
    private let provider = MoyaProvider<ScheduleCategoryAPI>(
        plugins: [
            NetworkLoggerPlugin(configuration: .init(
                logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
            ))
        ]
    )
    
    func fetchCategories() async throws -> [ScheduleCategory] {
        let response = try await provider.requestAsync(.fetchCategories)

        let decoded = try JSONDecoder().decode(
            BaseResponse<[ScheduleCategoryResponseDTO]>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            return []
        }

        return result.map { $0.toDomain() }

    }
    
    func createCategory(name: String, colorCode: String) async throws -> ScheduleCategory {

        let requestDTO = ScheduleCategoryRequestDTO(
            name: name,
            colorCode: colorCode
        )

        let response = try await provider.requestAsync(
            .createCategory(request: requestDTO)
        )

        let decoded = try JSONDecoder().decode(
            BaseResponse<ScheduleCategoryResponseDTO>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            throw APIError.transport("응답 데이터가 없습니다.")
        }

        return result.toDomain()
    }


    
    func updateCategory(id: Int, name: String, colorCode: String) async throws -> ScheduleCategory {

        let requestDTO = ScheduleCategoryRequestDTO(
            name: name,
            colorCode: colorCode
        )

        let response = try await provider.requestAsync(
            .updateCategory(id: id, request: requestDTO)
        )

        let decoded = try JSONDecoder().decode(
            BaseResponse<ScheduleCategoryResponseDTO>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            throw APIError.transport("응답 데이터가 없습니다.")
        }

        return result.toDomain()
    }

    
    func deleteCategory(id: Int) async throws {
        _ = try await provider.requestAsync(.deleteCategory(id: id))
    }
    
    
}


