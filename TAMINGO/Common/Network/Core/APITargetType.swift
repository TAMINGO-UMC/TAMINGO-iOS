//
//  APITargetType.swift
//  TAMINGO
//
//  Created by 김도연 on 1/16/26.
//

import Foundation
import Moya

protocol APITargetType: TargetType {}

extension APITargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("Invalid Base URL")
        }
        return url
    }
    
    var validationType: ValidationType { .successCodes }
}
