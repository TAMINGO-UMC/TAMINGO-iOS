////
////  CategoryServiceProtocol.swift
////  TAMINGO
////
////  Created by 권예원 on 2/3/26.
////
//
//
//import Combine
//import Foundation
//
//protocol CategoryServiceProtocol {
//    func fetchCategories() async throws -> [CategoryResponseDTO]
//}
//
//struct VoidResponse: Decodable {}
//
//final class TodoCategoryService {
//
//    private let provider = MoyaProvider<TodoCategoryAPI>()
//
//    func fetchCategories() async throws -> [CategoryResponseDTO] {
//        let response: BaseResponse<[CategoryResponseDTO]> =
//            try await provider.request(
//                .init(endpoint: .fetchCategories)
//            )
//
//        guard let result = response.result else {
//            return []
//        }
//
//        return result
//    }
//
//    func createCategory(dto: CreateTodoCategoryRequestDTO) async throws -> CategoryResponseDTO {
//        let response: BaseResponse<CategoryResponseDTO> =
//            try await provider.request(
//                .init(endpoint: .createCategory(dto))
//            )
//
//        guard let result = response.result else {
//            throw NetworkError.emptyData
//        }
//
//        return result
//    }
//
//    func updateCategory(id: Int, dto: UpdateTodoCategoryRequestDTO) async throws {
//        let _: BaseResponse<VoidResponse> =
//            try await provider.request(
//                .init(endpoint: .updateCategory(id: id, dto))
//            )
//    }
//
//    func deleteCategory(id: Int) async throws {
//        let _: BaseResponse<VoidResponse> =
//            try await provider.request(
//                .init(endpoint: .deleteCategory(id: id))
//            )
//    }
//}
