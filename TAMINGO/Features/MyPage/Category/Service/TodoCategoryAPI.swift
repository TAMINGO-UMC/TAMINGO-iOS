//
//  TodoCategoryAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
import Moya
import Alamofire

enum TodoCategoryAPI {
    case fetchCategories
    case createCategory(request: TodoCategoryRequestDTO)
    case updateCategory(id: Int, request: TodoCategoryRequestDTO)
    case deleteCategory(id: Int)
}

extension TodoCategoryAPI : APITargetType {
    var path: String {
        switch self {
        case .fetchCategories, .createCategory:
            return "/api/todo-categories"
        case .updateCategory(let id, _),
             .deleteCategory(let id):
            return "/api/todo-categories/\(id)"
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
            
        case .deleteCategory(_):
            return .requestPlain
        }
    }

    
}
