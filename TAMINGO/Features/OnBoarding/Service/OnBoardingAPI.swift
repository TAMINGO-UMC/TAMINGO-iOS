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
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2IiwiaWF0IjoxNzcwNDkxNzI1LCJleHAiOjE3NzA0OTUzMjV9.XLoz3cHJed2d4k-uhvCfp55QCYMSdPA0Mb_BUi6c6eI"
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

