//
//  ScheduleCategoryAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
import Moya
import Alamofire

enum ScheduleCategoryAPI {
    case fetchCategories
    case createCategory(request: ScheduleCategoryRequestDTO)
    case updateCategory(id: Int, request: ScheduleCategoryRequestDTO)
    case deleteCategory(id: Int)
}

extension ScheduleCategoryAPI : APITargetType {
    var path: String {
        switch self {
        case .fetchCategories, .createCategory:
            return "/api/schedule-categories"
        case .updateCategory(let id, _),
             .deleteCategory(let id):
            return "/api/schedule-categories/\(id)"
        }

    }
    
    var method: Moya.Method {
        switch self {
        case .fetchCategories:
            return .get
        case .createCategory:
            return .post
        case .updateCategory:
            return .patch
        case .deleteCategory:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .fetchCategories:
            return .requestPlain

        case .createCategory(let request):
            return .requestJSONEncodable(request)

        case .updateCategory(_, let request):
            return .requestJSONEncodable(request)
            
        case .deleteCategory:
            return .requestPlain
        }
    }
    
    
}
