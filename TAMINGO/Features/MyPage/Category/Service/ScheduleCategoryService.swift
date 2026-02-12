//
//  ScheduleCategoryService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Alamofire
import Foundation
import Moya

protocol ScheduleCategoryServiceProtocol {
    func fetchCategories() async throws -> [ScheduleCategory]
    func createCategory(name: String, colorCode: String) async throws -> ScheduleCategory
    func updateCategory(id: Int, name: String, colorCode: String) async throws -> ScheduleCategory
    func deleteCategory(id: Int) async throws
}

final class ScheduleCategoryService: ScheduleCategoryServiceProtocol {
    
    // 1. Interceptor가 포함된 Session 생성
    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    // 2. provider 초기화 시 session 주입
    private let provider: MoyaProvider<ScheduleCategoryAPI>
    
    init() {
        self.provider = MoyaProvider<ScheduleCategoryAPI>(
            session: session, // 여기에 session을 넣어줘야 401 발생 시 interceptor가 작동합니다.
            plugins: [
                NetworkLoggerPlugin(configuration: .init(
                    logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
                ))
            ]
        )
    }
    
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


