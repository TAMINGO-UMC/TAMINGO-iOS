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

extension OnboardingAPI: APITargetType {

    var path: String {
        "/api/onboarding"
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


}

