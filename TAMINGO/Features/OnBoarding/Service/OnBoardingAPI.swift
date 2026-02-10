//
//  OnboardingAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/8/26.
//

import Foundation
import Moya
import Alamofire

enum OnboardingAPI {
    case complete(request: OnboardingRequestDTO)
}

enum AuthConstants {
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2IiwiaWF0IjoxNzcwNzA1NDk2LCJleHAiOjE3NzA3MDkwOTZ9.HK9g2n4k4Wc0MUWYrqmR2rzH3IznZPQTUwGED_6IgwE"
    static let userId = 6
}

extension OnboardingAPI: APITargetType {

    var path: String {
        "api/onboarding"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        switch self {
        case let .complete(request):
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AuthConstants.accessToken)",
            "X-USER-ID": "\(AuthConstants.userId)"
        ]
    }

}

