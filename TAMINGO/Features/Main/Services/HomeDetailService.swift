//
//  HomeDetailService.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

final class HomeDetailService {

    private let baseURL = Config.baseURL
    
    func fetchScheduleDetail(
        scheduleId: Int,
        accessToken: String,
        completion: @escaping (Result<ScheduleDetail, Error>) -> Void
    ) {
        let url = URL(string: "\(Config.baseURL)/api/home/schedules/\(scheduleId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else { return }

            do {
                let decoded = try JSONDecoder().decode(
                    ScheduleDetailResponseDTO.self,
                    from: data
                )
                completion(.success(decoded.result.toModel()))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }

}


// MARK: - 동선 연계
extension HomeDetailService {

    // 동선 연계 수락
    func acceptRoute(
        scheduleId: Int,
        request: RouteAcceptRequestDTO,
        accessToken: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let url = URL(
            string: "\(baseURL)/api/home/suggestions/route/\(scheduleId)/accept"
        )!

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { _, _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
        .resume()
    }

    // 동선 연계 삭제
    func rejectRoute(
        scheduleId: Int,
        accessToken: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let url = URL(
            string: "\(baseURL)/api/home/suggestions/route/\(scheduleId)/reject"
        )!

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { _, _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
        .resume()
    }
}
