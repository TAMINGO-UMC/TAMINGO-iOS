//
//  TodoCategoryAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import Foundation
import Moya
import Alamofire

struct TodoCategoryAPI: APITargetType {

    enum Endpoint {
        case fetchCategories
        case createCategory(CreateTodoCategoryRequestDTO)
        case updateCategory(id: Int, UpdateTodoCategoryRequestDTO)
        case deleteCategory(id: Int)
    }

    let endpoint: Endpoint

    // MARK: - Path
    var path: String {
        switch endpoint {
        case .fetchCategories, .createCategory:
            return "/api/todo-categories"

        case .updateCategory(let id, _),
             .deleteCategory(let id):
            return "/api/todo-categories/\(id)"
        }
    }

    // MARK: - Method
    var method: Moya.Method {
        switch endpoint {
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

    // MARK: - Task
    var task: Task {
        switch endpoint {
        case .fetchCategories, .deleteCategory:
            return .requestPlain

        case .createCategory(let dto):
            return .requestJSONEncodable(dto)

        case .updateCategory(_, let dto):
            return .requestJSONEncodable(dto)
        }
    }

    // MARK: - Headers
    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
//            "Authorization": "Bearer \(TokenManager.accessToken)"
        ]
    }

    // MARK: - SampleData (Moya Stub)
    var sampleData: Data {
        switch endpoint {
        case .fetchCategories:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": [
                {
                  "id": 1,
                  "name": "일상",
                  "iconCode": "home",
                  "colorCode": "#87CEEB"
                }
              ]
            }
            """.data(using: .utf8) ?? Data()

        case .createCategory:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-201",
              "message": "리소스가 생성되었습니다.",
              "result": {
                "id": 3,
                "name": "스터디",
                "iconCode": "book",
                "colorCode": "#2979FF"
              }
            }
            """.data(using: .utf8) ?? Data()

        case .updateCategory:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "수정되었습니다.",
              "result": null
            }
            """.data(using: .utf8) ?? Data()

        case .deleteCategory:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "삭제되었습니다.",
              "result": null
            }
            """.data(using: .utf8) ?? Data()
        }
    }
}
