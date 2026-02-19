//
//  OnBoardingService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/8/26.
//

import Moya
import Foundation
import Alamofire

final class OnboardingService {

    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()

    private let provider: MoyaProvider<OnboardingAPI>

    init() {
        self.provider = MoyaProvider<OnboardingAPI>(
            session: session,
            plugins: [
                NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
            ]
        )
    }

    func completeOnboarding(
        request: OnboardingRequestDTO
    ) async throws -> Bool {

        let response = try await provider.requestAsync(
            .complete(request: request)
        )

        if !(200...299).contains(response.statusCode) {

            let errorDTO = try? JSONDecoder().decode(
                APIErrorResponseDTO.self,
                from: response.data
            )

            let message = errorDTO?.message ?? "알 수 없는 오류입니다."

            throw APIError.server(
                status: response.statusCode,
                message: message
            )
        }

        // 성공 응답 디코딩
        let decoded = try JSONDecoder().decode(
            BaseResponse<OnboardingResultDTO>.self,
            from: response.data
        )

        return decoded.result?.onboardingCompleted == true
    }
}
