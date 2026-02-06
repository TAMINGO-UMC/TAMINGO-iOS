//
//  ScheduleTarget.swift
//  TAMINGO
//
//  Created by 김도연 on 1/30/26.
//

import Foundation
import Moya
import Alamofire

enum ScheduleTarget {
    case createSchedule(body: ScheduleRequestDTO)
    case aiInference(title: String)
    case updateSchedule(id: Int, body: ScheduleRequestDTO)
    case aiFavoritePlaces(body: addPlaceDTO)
    case getFavoritePlaces
    case getScheduleList(date: String)
    case getScheduleDetail(id: Int)
    case getCategories
    case getMonthly(date: String)
}

extension ScheduleTarget: APITargetType {
    // MARK: - Path
    var path: String {
        switch self {
        case .createSchedule:
            return "/api/schedules/create"
        case .aiInference:
            return "/api/schedules/ai-inference"
        case .updateSchedule(let id, _):
            return "/api/schedules/\(id)"
        case .aiFavoritePlaces:
            return "/api/favorite-places/ai"
        case .getFavoritePlaces:
            return "/api/schedules/favorite-places"
        case .getScheduleList:
            return "/api/schedules"
        case .getScheduleDetail(let id):
            return "/api/schedules/\(id)"
        case .getCategories:
            return "/api/schedules-categories"
        case .getMonthly:
            return "/api/schedules/calendar"
        }
    }
    
    // MARK: - Method
    var method: Moya.Method {
        switch self {
        case .createSchedule, .aiInference, .aiFavoritePlaces:
            return .post
        case .updateSchedule:
            return .put
        case .getFavoritePlaces, .getScheduleList, .getScheduleDetail, .getCategories, .getMonthly:
            return .get
        }
    }
    
    // MARK: - Task
    var task: Moya.Task {
        switch self {
        case .createSchedule(let body):
            return .requestJSONEncodable(body)
            
        case .aiInference(let title):
            return .requestParameters(
                parameters: ["title": title],
                encoding: JSONEncoding.default
            )
        case .aiFavoritePlaces(let body):
            return .requestJSONEncodable(body)
            
        case .updateSchedule(_, let body):
            return .requestJSONEncodable(body)
            
        case .getScheduleList(let date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.default
            )
        case .getMonthly(let date):
            return .requestParameters(
                parameters: ["yearMonth": date],
                encoding: URLEncoding.default
            )
            
        case .getFavoritePlaces, .getScheduleDetail, .getCategories:
            return .requestPlain
        }
    }
    
    // MARK: - Headers
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    // MARK: - Sample Data (Mock Response)
    var sampleData: Data {
        switch self {
            
            // 일정 생성 결과
        case .createSchedule:
            let json = """
            {
                "isSuccess": true,
                "code": "SUCCESS-200",
                "message": "요청에 성공했습니다.",
                "result": {
                    "scheduleId": 1
                }
            }
            """
            return Data(json.utf8)
            
            // AI 추론 결과
        case .aiInference:
            let json = """
            {
                "isSuccess": true,
                "code": "SUCCESS-200",
                "message": "요청에 성공했습니다.",
                "result": {
                    "aiInference": {
                        "placeName": "광운대 중앙도서관",
                        "address": "서울 노원구 광운로 20",
                        "latitude": 37.6197,
                        "longitude": 127.0598,
                        "category": "공부"
                    },
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
                            "placeName": "교보문고 광화문점"
                        }
                    ],
                    "isFavoriteRecommendation": true
                }
            }
            """
            return Data(json.utf8)
            
            // 일정 수정 결과
        case .updateSchedule:
            let json = """
            {
                "isSuccess": true,
                "code": "SUCCESS-200",
                "message": "요청에 성공했습니다.",
                "result": "일정이 성공적으로 수정되었습니다."
            }
            """
            return Data(json.utf8)
            
            // 내 장소 가져오기
        case .getFavoritePlaces:
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
            
        case .aiFavoritePlaces:
            let json = """
            {
              "isSuccess": true,
              "code": "SUCCESS-201",
              "message": "리소스가 생성되었습니다.",
              "result": 1
            }
            """
            return Data(json.utf8)
            
            // 일정 목록 조회
        case .getScheduleList(let date):
            // 1. 특정 날짜 (예: 1월 31일)에 대한 데이터
            if date == "2026-01-28" {
                let json = """
                        {
                            "isSuccess": true,
                            "code": "SUCCESS-200",
                            "message": "요청에 성공했습니다.",
                            "result": [
                                {
                                    "scheduleId": 12,
                                    "title": "동국대 도서관",
                                    "startTime": "2026-01-28T09:00:00",
                                    "endTime": "2026-01-28T10:00:00",
                                    "placeName": "동국대학교",
                                    "category": "공부"
                                },
                                {
                                    "scheduleId": 101,
                                    "title": "Mock 데이터 테스트",
                                    "startTime": "2026-01-28T14:00:00",
                                    "endTime": "2026-01-28T15:00:00",
                                    "placeName": "집",
                                    "category": "업무"
                                }
                            ]
                        }
                        """
                return Data(json.utf8)
            }
            else if date == "2026-01-31" {
                let json = """
                        {
                            "isSuccess": true,
                            "code": "SUCCESS-200",
                            "message": "요청에 성공했습니다.",
                            "result": [
                                {
                                    "scheduleId": 14,
                                    "title": "타밍고",
                                    "startTime": "2026-01-31T20:00:00",
                                    "endTime": "2026-01-31T21:00:00",
                                    "placeName": "광운대학교",
                                    "category": "업무"
                                }
                            ]
                        }
                        """
                return Data(json.utf8)
            }
            else {
                let json = """
                        {
                            "isSuccess": true,
                            "code": "SUCCESS-200",
                            "message": "요청에 성공했습니다.",
                            "result": []
                        }
                        """
                return Data(json.utf8)
            }
            
            // 일정 상세 조회
        case .getScheduleDetail:
            let json = """
            {
                "isSuccess": true,
                "code": "SUCCESS-200",
                "message": "요청에 성공했습니다.",
                "result": {
                    "scheduleId": 15,
                    "title": "광운대학교",
                    "scheduleDate": "2026-01-31",
                    "startTime": "16:00",
                    "endTime": "17:00",
                    "placeName": "광운대학교",
                    "address": "서울 노원구 광운로 20",
                    "latitude": 37.6192404638865,
                    "longitude": 127.058270608867,
                    "category": "업무",
                    "repeatType": "WEEKLY",
                    "repeatEndDate": "2026-02-28",
                    "memo": "string",
                    "linkedTodos": [
                        {
                            "todoId": 8,
                            "title": "메가커피 중랑구청점",
                            "placeName": "메가커피 중랑구청점"
                        },
                        {
                            "todoId": 10,
                            "title": "도서관 1층 카페 가기",
                            "placeName": "국립중앙도서관"
                        }
                    ],
                    "candidateTodos": [
                        {
                            "todoId": 7,
                            "title": "메가커피 중랑구청점",
                            "placeName": "메가커피 중랑구청점"
                        },
                        {
                            "todoId": 9,
                            "title": "도서관 1층 카페 가기",
                            "placeName": "국립중앙도서관"
                        },
                        {
                            "todoId": 11,
                            "title": "도서관 1층 카페 가기",
                            "placeName": "국립중앙도서관"
                        },
                        {
                            "todoId": 12,
                            "title": "도서관 1층 카페 가기",
                            "placeName": null
                        }
                    ]
                }
            }
            """
            return Data(json.utf8)
            
            // 카테고리 조회
        case .getCategories:
            let json = """
                {
                  "isSuccess": true,
                  "code": "SUCCESS-200",
                  "message": "요청에 성공했습니다.",
                  "result": [
                    {
                      "id": 1,
                      "name": "공부",
                      "iconCode": "study",
                      "colorCode": "#22C7A9"
                    },
                    {
                      "id": 2,
                      "name": "업무",
                      "iconCode": "work",
                      "colorCode": "#903ACD"
                    },
                    {
                      "id": 3,
                      "name": "약속",
                      "iconCode": "run",
                      "colorCode": "#FFC576"
                    }
                  ]
                }
                """
            return Data(json.utf8)
            
            // 월별 일정 조회
        case .getMonthly(let date):
            switch date {
            case "2026-01":
                return stub_2026_01
            case "2026-02":
                return stub_2026_02
            case "2026-03":
                return stub_2026_03
            default:
                return Data("{}".utf8)
            }
        }
    }
}

// 1월 데이터
private var stub_2026_01: Data {
    let json = """
    {
        "isSuccess": true,
        "code": "SUCCESS-200",
        "message": "요청에 성공했습니다.",
        "result": {
            "schedules": [
                { "scheduleId": 1, "title": "광운대 도서관 방문", "startTime": "2026-01-28T09:00:00", "endTime": "2026-01-28T10:00:00", "placeName": "광운대학교", "category": "공부" },
                { "scheduleId": 2, "title": "중랑구청 5시", "startTime": "2026-01-28T17:00:00", "endTime": "2026-01-28T18:00:00", "placeName": "중랑구청", "category": "약속" },
                { "scheduleId": 14, "title": "타밍고", "startTime": "2026-01-28T20:00:00", "endTime": "2026-01-28T21:00:00", "placeName": "광운대", "category": "업무" },
                { "scheduleId": 7, "title": "타밍고 미팅", "startTime": "2026-01-30T09:00:00", "endTime": "2026-01-30T10:00:00", "placeName": "광운대학교", "category": "업무" },
                { "scheduleId": 23, "title": "공릉역 2번 출구", "startTime": "2026-01-30T18:00:00", "endTime": "2026-01-30T19:00:00", "placeName": "공릉역", "category": "약속" }
            ],
            "categories": [
                { "categoryId": 1, "name": "공부", "colorCode": "#4A90E2" },
                { "categoryId": 2, "name": "운동", "colorCode": "#E74C3C" },
                { "categoryId": 3, "name": "업무", "colorCode": "#F1C40F" },
                { "categoryId": 4, "name": "약속", "colorCode": "#2ECC71" },
                { "categoryId": 5, "name": "취미", "colorCode": "#9B59B6" }
            ]
        }
    }
    """
    return Data(json.utf8)
}

// 2월 데이터
private var stub_2026_02: Data {
    let json = """
    {
        "isSuccess": true,
        "code": "SUCCESS-200",
        "message": "요청에 성공했습니다.",
        "result": {
            "schedules": [
                { "scheduleId": 101, "title": "발렌타인데이 준비", "startTime": "2026-02-13T18:00:00", "endTime": "2026-02-13T20:00:00", "placeName": "백화점", "category": "약속" },
                { "scheduleId": 102, "title": "팀 프로젝트 회의", "startTime": "2026-02-14T14:00:00", "endTime": "2026-02-14T16:00:00", "placeName": "스타벅스", "category": "업무" },
                { "scheduleId": 103, "title": "헬스장", "startTime": "2026-02-15T19:00:00", "endTime": "2026-02-15T21:00:00", "placeName": "짐박스", "category": "운동" },
                { "scheduleId": 104, "title": "졸업식 참석", "startTime": "2026-02-20T10:00:00", "endTime": "2026-02-20T13:00:00", "placeName": "학교 대강당", "category": "약속" }
            ],
            "categories": [
                { "categoryId": 1, "name": "공부", "colorCode": "#4A90E2" },
                { "categoryId": 2, "name": "운동", "colorCode": "#E74C3C" },
                { "categoryId": 3, "name": "업무", "colorCode": "#F1C40F" },
                { "categoryId": 4, "name": "약속", "colorCode": "#2ECC71" },
                { "categoryId": 5, "name": "취미", "colorCode": "#9B59B6" }
            ]
        }
    }
    """
    return Data(json.utf8)
}

// 3월 데이터
private var stub_2026_03: Data {
    let json = """
    {
        "isSuccess": true,
        "code": "SUCCESS-200",
        "message": "요청에 성공했습니다.",
        "result": {
            "schedules": [
                { "scheduleId": 201, "title": "개강 총회", "startTime": "2026-03-02T18:00:00", "endTime": "2026-03-02T22:00:00", "placeName": "학교 앞 술집", "category": "약속" },
                { "scheduleId": 202, "title": "전공 수업(자료구조)", "startTime": "2026-03-03T09:00:00", "endTime": "2026-03-03T12:00:00", "placeName": "공학관 101호", "category": "공부" },
                { "scheduleId": 203, "title": "도서관 자리 잡기", "startTime": "2026-03-04T08:00:00", "endTime": "2026-03-04T09:00:00", "placeName": "중앙도서관", "category": "공부" },
                { "scheduleId": 204, "title": "동아리 신입생 환영회", "startTime": "2026-03-10T19:00:00", "endTime": "2026-03-10T23:00:00", "placeName": "동아리방", "category": "취미" }
            ],
            "categories": [
                { "categoryId": 1, "name": "공부", "colorCode": "#4A90E2" },
                { "categoryId": 2, "name": "운동", "colorCode": "#E74C3C" },
                { "categoryId": 3, "name": "업무", "colorCode": "#F1C40F" },
                { "categoryId": 4, "name": "약속", "colorCode": "#2ECC71" },
                { "categoryId": 5, "name": "취미", "colorCode": "#9B59B6" }
            ]
        }
    }
    """
    return Data(json.utf8)
}
