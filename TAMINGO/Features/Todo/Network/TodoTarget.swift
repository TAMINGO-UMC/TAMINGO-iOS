
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
    
    // 5. 자주 가는 장소 목록 조회
    case getFrequentPlaces
    
    // 6. 장소 선택 시 관련 할일 조회
    case getRelatedTodos(body: RelatedTodosRequestDTO)
    
    // 7. 할일 상세 조회
    case getTodoDetail(id: Int)
    
    // 8. 할일 완료 체크
    case updateTodoCompletion(id: Int, body: TodoCompletionRequestDTO)
}

// MARK: - TargetType 구현
extension TodoTarget: APITargetType {
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getMyPlaces:
            return "/api/todos/places/my"
        case .createTodo:
            return "/api/todos"
        case .updateTodo(let id, _):
            return "/api/todos/\(id)"
        case .aiInference:
            return "/api/todos/ai-inference"
        case .getFrequentPlaces:
            return "/api/todos/places/frequent"
        case .getRelatedTodos:
            return "/api/todos/related"
        case .getTodoDetail(let id):
            return "/api/todos/\(id)"
        case .updateTodoCompletion(let id, _):
            return "/api/todos/\(id)/completion"
        }
    }
    
    // MARK: - Method
    var method: Moya.Method {
        switch self {
        case .createTodo, .aiInference, .getRelatedTodos:
            return .post
        case .updateTodo, .updateTodoCompletion:
            return .put
        case .getMyPlaces, .getFrequentPlaces, .getTodoDetail:
            return .get
        }
    }
    
    // MARK: - Task
    var task: Moya.Task {
        switch self {
        case .createTodo(let body):
            return .requestJSONEncodable(body)
            
        case .aiInference(let title):
            return .requestParameters(
                parameters: ["title": title],
                encoding: JSONEncoding.default
            )
            
        case .updateTodo(_, let body):
            return .requestJSONEncodable(body)
            
        case .getRelatedTodos(let body):
            return .requestJSONEncodable(body)
            
        case .updateTodoCompletion(_, let body):
            return .requestJSONEncodable(body)
            
        case .getMyPlaces, .getFrequentPlaces, .getTodoDetail:
            return .requestPlain
        }
    }
    
    // MARK: - Headers
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    // MARK: - Sample Data (Mock Response for Testing)
    var sampleData: Data {
        switch self {
            
        // 1. 내장소 가져오기
        case .getMyPlaces:
            let json = """
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
                },
                {
                  "id": 3,
                  "name": "광운대학교",
                  "address": "서울 노원구 광운로 20",
                  "latitude": 37.6192404638865,
                  "longitude": 127.058270608867
                }
              ]
            }
            """
            return Data(json.utf8)
            
        // 2. 할 일 생성
        case .createTodo:
            let json = """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "todoId": 1
              }
            }
            """
            return Data(json.utf8)
            
        // 3. 할 일 수정
        case .updateTodo:
            let json = """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": "할 일이 성공적으로 수정되었습니다."
            }
            """
            return Data(json.utf8)
            
        // 4. AI 추론
        case .aiInference:
            let json = """
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
            """
            return Data(json.utf8)
            
        // 5. 자주 가는 장소 목록 조회
        case .getFrequentPlaces:
            let json = """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "places": [
                  {
                    "placeId": 1,
                    "name": "집",
                    "address": "서울시 노원구 광운로 21",
                    "latitude": 37.61972,
                    "longitude": 127.05981,
                    "weeklyVisitCount": 6
                  },
                  {
                    "placeId": 2,
                    "name": "학교",
                    "address": "서울시 노원구 광운로 20",
                    "latitude": 37.61980,
                    "longitude": 127.05990,
                    "weeklyVisitCount": 6
                  }
                ]
              }
            }
            """
            return Data(json.utf8)
            
        // 6. 장소 선택 시 관련 할일 조회
        case .getRelatedTodos:
            let json = """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": {
                "nearbyTodos": [
                  {
                    "todoId": 1,
                    "title": "도서 반납",
                    "placeName": "중앙도서관"
                  }
                ],
                "candidateTodos": [
                  {
                    "todoId": 2,
                    "title": "동아리 회비 입금",
                    "placeName": null
                  },
                  {
                    "todoId": 3,
                    "title": "전공 책 구매",
                    "placeName": "교보문고"
                  }
                ],
                "isFavoriteRecommendation": true
              }
            }
            """
            return Data(json.utf8)
            
        // 7. 할일 상세 조회
        case .getTodoDetail:
            let json = """
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
                  },
                  {
                    "scheduleId": 26,
                    "title": "타밍고 qa",
                    "placeName": "교대역 2호선 3번출구"
                  }
                ],
                "isFavoriteRecommendation": false
              }
            }
            """
            return Data(json.utf8)
            
        // 8. 할일 완료 체크
        case .updateTodoCompletion:
            let json = """
            {
              "isSuccess": true,
              "code": "SUCCESS-200",
              "message": "요청에 성공했습니다.",
              "result": "상태가 변경되었습니다."
            }
            """
            return Data(json.utf8)
        }
    }
}
