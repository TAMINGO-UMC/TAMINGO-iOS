//
//  HomeService.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/7/26.
//

import Foundation

final class HomeService {

    private let baseURL = Config.baseURL

    func fetchTodayTimeline(
        accessToken: String,
        completion: @escaping (Result<HomeScheduleResponseDTO, Error>) -> Void
    ) {
        let url = URL(string: "\(baseURL)/api/home/today")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error {
                completion(.failure(error))
                return
            }

            guard let data else { return }

            do {
                let decoded = try JSONDecoder().decode(
                    HomeScheduleResponseDTO.self,
                    from: data
                )
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

// MARK: - 틈새 일정
extension HomeService {

    // 틈새 일정 편성
    func acceptSuggestion(
        suggestionId: Int,
        accessToken: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let url = URL(
            string: "\(Config.baseURL)/api/home/suggestions/\(suggestionId)/accept"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
        .resume()
    }

    // 틈새 일정 나중에
    func rejectSuggestion(
        suggestionId: Int,
        accessToken: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let url = URL(
            string: "\(Config.baseURL)/api/home/suggestions/\(suggestionId)/reject"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
        .resume()
    }
}
