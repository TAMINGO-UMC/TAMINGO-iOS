//
//  FavoritePlacesService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/8/26.
//

import Alamofire
import Foundation
import Moya

protocol FavoritePlacesServiceProtocol {
    func fetchPlaces() async throws -> [FavoritePlace]
    func createPlace(_ dto: PlaceRequestDTO) async throws -> Int
    func updatePlace(placeId: Int, dto: PlaceRequestDTO) async throws
    func deletePlace(placeId: Int) async throws
}


final class FavoritePlacesService: FavoritePlacesServiceProtocol {

    // [수정] Interceptor가 포함된 Session 생성
    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    // [수정] provider 변수 선언
    private let provider: MoyaProvider<FavoritePlaceAPI>
    
    // [수정] init에서 session 주입
    init() {
        self.provider = MoyaProvider<FavoritePlaceAPI>(
            session: session, // 핵심: Interceptor 연결
            plugins: [
                NetworkLoggerPlugin(configuration: .init(
                    logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
                ))
            ]
        )
    }

    // MARK: - 조회
    func fetchPlaces() async throws -> [FavoritePlace] {

        let response = try await provider.requestAsync(.fetchPlaces)

        let decoded = try JSONDecoder().decode(
            BaseResponse<[FavoritePlaceDTO]>.self,
            from: response.data
        )
        guard let result = decoded.result else {
            return []
        }
        return result.map { $0.toDomain() }
    }


    // MARK: - 등록
    func createPlace(_ dto: PlaceRequestDTO) async throws -> Int {
        let response = try await provider.requestAsync(.createPlace(dto))

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
    func updatePlace(placeId: Int, dto: PlaceRequestDTO) async throws {
        let response = try await provider.requestAsync(.updatePlace(placeId: placeId, dto: dto))

        guard (200..<300).contains(response.statusCode) else {
            throw APIError.server(
                status: response.statusCode,
                message: "장소 수정에 실패했습니다."
            )
        }
    }



    // MARK: - 삭제
    func deletePlace(placeId: Int) async throws {
        let response = try await provider.requestAsync(.deletePlace(placeId: placeId))
        
        guard (200..<300).contains(response.statusCode) else {
            throw APIError.server(
                status: response.statusCode,
                message: "장소 삭제에 실패했습니다."
            )
        }
    }

}

