//
//  AddressSearchService.swift
//  TAMINGO
//
//  Created by 권예원 on 1/30/26.
//
import Foundation

final class PlaceSearchService {
    
    static let shared = PlaceSearchService()
    private init() {}
    
    func search(query: String) async throws -> [AddressDocument] {
        var components = URLComponents(
            string: "https://dapi.kakao.com/v2/local/search/address.json"
        )

        components?.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]

        // URL 조립 결과에 대한 검증
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.addValue(
            "KakaoAK \(Config.kakaoAddressAPIKey)",
            forHTTPHeaderField: "Authorization"
        )


        let (data, response) = try await URLSession.shared.data(for: request)

        // HTTP 상태 코드 검증
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(AddressResponse.self, from: data)
        return decoded.documents
    }

}
