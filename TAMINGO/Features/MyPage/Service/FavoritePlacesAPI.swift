//
//  FavoritePlacesAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/8/26.
//

import Foundation
import Moya
import Alamofire

enum FavoritePlaceAPI {
    case fetchPlaces
    case createPlace(PlaceRequestDTO)
    case updatePlace(placeId: Int, dto: PlaceRequestDTO)
    case deletePlace(placeId: Int)
}

enum AuthConstants {
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2IiwiaWF0IjoxNzcwNjM1NTAxLCJleHAiOjE3NzA2MzkxMDF9.LN84yqwGfLp1pUEUW643Es1bF1Aa8EwloSuQhZknnoM"
    static let userId = 6
}

extension FavoritePlaceAPI: APITargetType {
    var path: String{
        switch self {
        case .fetchPlaces, .createPlace:
            return "/api/favorite-places"

        case .updatePlace(let placeId, _),
             .deletePlace(let placeId):
            return "/api/favorite-places/\(placeId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPlaces:
            return .get
        case .createPlace:
            return .post
        case .updatePlace:
            return .patch
        case .deletePlace:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .fetchPlaces, .deletePlace:
            return .requestPlain

        case .createPlace(let dto),
             .updatePlace(_, let dto):
            return .requestJSONEncodable(dto)
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

