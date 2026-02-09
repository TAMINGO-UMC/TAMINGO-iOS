//
//  FavoritePlacesService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/8/26.
//

import Foundation
import Moya

protocol FavoritePlacesServiceProtocol {
    func fetchPlaces() async throws -> [FavoritePlace]
    func createPlace(_ dto: PlaceRequestDTO) async throws -> Int
    func updatePlace(placeId: Int, dto: PlaceRequestDTO) async throws -> Int
    func deletePlace(placeId: Int) async throws
}

final class FavoritePlacesService: FavoritePlacesServiceProtocol {

    private let provider = MoyaProvider<FavoritePlaceAPI>(
        plugins: [
            NetworkLoggerPlugin(configuration: .init(
                logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
            ))
        ]
    )

    // MARK: - 조회
    func fetchPlaces() async throws -> [FavoritePlace] {

        let response = try await request(.fetchPlaces)

        let decoded = try JSONDecoder().decode(
            BaseResponse<[FavoritePlaceDTO]>.self,
            from: response.data
        )

        return decoded.result.map { $0.toDomain() }!
    }


    // MARK: - 등록
    func createPlace(_ dto: PlaceRequestDTO) async throws -> Int {
        let response = try await request(.createPlace(dto))

        let decoded = try JSONDecoder().decode(
            BaseResponse<Int>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            throw APIError.server(
                status: -1,
                message: "서버 응답에 result가 없습니다."
            )
        }

        return result
    }



    // MARK: - 수정
    func updatePlace(placeId: Int, dto: PlaceRequestDTO) async throws -> Int {
        let response = try await request(.updatePlace(placeId: placeId, dto: dto))

        let decoded = try JSONDecoder().decode(
            BaseResponse<Int>.self,
            from: response.data
        )
        
        guard let result = decoded.result else {
            throw APIError.server(
                status: -1,
                message: "서버 응답에 result가 없습니다."
            )
        }

        return result
    }


    // MARK: - 삭제
    func deletePlace(placeId: Int) async throws {
        let response = try await request(.deletePlace(placeId: placeId))
        
        guard (200..<300).contains(response.statusCode) else {
            throw APIError.server(
                status: response.statusCode,
                message: "장소 삭제에 실패했습니다."
            )
        }
    }

}

private extension FavoritePlacesService {

    private func request(_ target: FavoritePlaceAPI) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)

                case .failure(let error):
                    if let response = error.response,
                       let apiErrorDTO = try? JSONDecoder().decode(
                            APIErrorResponseDTO.self,
                            from: response.data
                       ) {
                        continuation.resume(
                            throwing: APIError.server(
                                status: apiErrorDTO.status,
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
