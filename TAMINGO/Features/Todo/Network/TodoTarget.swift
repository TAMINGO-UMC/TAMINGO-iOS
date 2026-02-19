//
//  TodoTarget.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/5/26.
//  Updated: 2/8/26 - headers 오버라이드 제거 (Authorization 헤더 복원)
//

import Foundation
import Moya
import Alamofire

enum TodoTarget {
    // 1. 내장소 가져오기
    case getMyPlaces
    
    // 2. 할 일 생성
    case createTodo(body: TodoCreateRequestDTO)
    
    // 3. 할 일 수정
    case updateTodo(id: Int, body: TodoUpdateRequestDTO)
    
    // 4. AI 추론
    case aiInference(title: String)
    
    // 5. 사용자 장소 수정 시 일정 추천
    case recommendSchedules(body: RecommendSchedulesRequestDTO)
    
    // 6. 할일 목록 조회
    case getTodoList(date: String)
    
    // 7. 할일 상세 조회
    case getTodoDetail(id: Int)
    
    // 8. 할일 완료 체크
    case updateTodoCompletion(id: Int, body: TodoCompletionRequestDTO)
    
    // 9. 할일 삭제
    case deleteTodo(id: Int)
    
    // 10. 카테고리 목록 조회
    case getCategories
}

// MARK: - APITargetType 구현
extension TodoTarget: APITargetType {
    
    var path: String {
        switch self {
        case .getMyPlaces:
            return "/api/favorite-places"
        case .createTodo:
            return "/api/todos"
        case .updateTodo(let id, _):
            return "/api/todos/\(id)"
        case .aiInference:
            return "/api/todos/ai-inference"
        case .recommendSchedules:
            return "/api/todos/recommend-schedules"
        case .getTodoList:
            return "/api/todos"
        case .getTodoDetail(let id):
            return "/api/todos/\(id)"
        case .updateTodoCompletion(let id, _):
            return "/api/todos/\(id)/check"
        case .deleteTodo(let id):
            return "/api/todos/\(id)"
        case .getCategories:
            return "/api/todo-categories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTodo, .aiInference, .recommendSchedules:
            return .post
        case .updateTodo:
            return .put
        case .updateTodoCompletion:
            return .patch
        case .deleteTodo:
            return .delete
        case .getMyPlaces, .getTodoList, .getTodoDetail, .getCategories:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createTodo(let body):
            return .requestJSONEncodable(body)
            
        case .aiInference(let title):
            let body = ["title": title]
            return .requestJSONEncodable(body)
            
        case .updateTodo(_, let body):
            return .requestJSONEncodable(body)
            
        case .recommendSchedules(let body):
            return .requestJSONEncodable(body)
            
        case .getTodoList(let date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.queryString
            )
            
        case .updateTodoCompletion(_, let body):
            return .requestJSONEncodable(body)
            
        case .getMyPlaces, .getTodoDetail, .deleteTodo, .getCategories:
            return .requestPlain
        }
    }
    
    // ✅ headers 오버라이드 제거!
    // APITargetType의 기본 구현이 자동으로 Authorization 헤더 추가
    // var headers: [String: String]? { ... }  // ❌ 삭제됨
    
    // MARK: - Sample Data (Stub용)
    var sampleData: Data {
        switch self {
            
        case .getMyPlaces:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": [
                {
                  "id": 2,
                  "name": "중랑구립정보도서관",
                  "address": "서울 중랑구 신내로15길 197",
                  "latitude": 37.61524044821545,
                  "longitude": 127.0869527012108
                }
              ]
            }
            """.data(using: .utf8)!
            
        case .createTodo:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "todoId": 1
              }
            }
            """.data(using: .utf8)!
            
        case .updateTodo:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "todoId": 17,
                "actualTargetDate": "2026-02-09"
              }
            }
            """.data(using: .utf8)!
            
        case .aiInference:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "todoInfo": {
                  "category": "업무",
                  "placeName": "광운대학교",
                  "address": "서울 노원구 광운로 20",
                  "latitude": 37.6192404638865,
                  "longitude": 127.058270608867,
                  "duration": 15
                }
              }
            }
            """.data(using: .utf8)!
            
        case .recommendSchedules:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "nearbySchedules": [
                  {
                    "scheduleId": 22,
                    "title": "도서관 가기",
                    "placeName": "중랑구립정보도서관"
                  }
                ],
                "candidateSchedules": [
                  {
                    "scheduleId": 25,
                    "title": "새빛관 빅데이터 강의",
                    "placeName": "광운대학교 새빛관"
                  }
                ],
                "isFavoriteRecommendation": true
              }
            }
            """.data(using: .utf8)!
            
        case .getTodoList:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "dailyTodos": [
                  {
                    "todoId": 35,
                    "title": "번장 대면 거래",
                    "categoryName": "일상",
                    "categoryColor": "#22C7A9",
                    "isChecked": true
                  }
                ],
                "backlogTodos": [
                  {
                    "todoId": 34,
                    "title": "api 구현",
                    "categoryName": "업무",
                    "categoryColor": "#FFC576",
                    "isChecked": false
                  }
                ]
              }
            }
            """.data(using: .utf8)!
            
        case .getTodoDetail:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "todoId": 18,
                "title": "당근 거래",
                "targetDate": "2026-02-05",
                "placeName": "중랑구청",
                "address": "서울 중랑구 봉화산로 179",
                "latitude": 37.6065432383975,
                "longitude": 127.092820287005,
                "duration": 10,
                "category": "일상",
                "repeatType": "NONE",
                "repeatEndDate": null,
                "linkedSchedule": [
                  {
                    "scheduleId": 22,
                    "title": "도서관 가기",
                    "placeName": "중랑구립정보도서관"
                  }
                ],
                "candidateSchedules": [
                  {
                    "scheduleId": 25,
                    "title": "새빛관 빅데이터 강의",
                    "placeName": "광운대학교 새빛관"
                  }
                ],
                "isFavoriteRecommendation": false
              }
            }
            """.data(using: .utf8)!
            
        case .updateTodoCompletion:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": "상태가 변경되었습니다."
            }
            """.data(using: .utf8)!
            
        case .deleteTodo:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "삭제에 성공했습니다.",
              "result": "삭제됨"
            }
            """.data(using: .utf8)!
            
        case .getCategories:
            return """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": [
                {
                  "id": 1,
                  "name": "업무",
                  "colorCode": "#FFC576"
                },
                {
                  "id": 2,
                  "name": "학업",
                  "colorCode": "#9DCAFF"
                },
                {
                  "id": 3,
                  "name": "운동",
                  "colorCode": "#FB9B9B"
                },
                {
                  "id": 4,
                  "name": "일상",
                  "colorCode": "#22C7A9"
                },
                {
                  "id": 5,
                  "name": "미지정",
                  "colorCode": "#D1D1D1"
                }
              ]
            }
            """.data(using: .utf8)!
        }
    }
}
