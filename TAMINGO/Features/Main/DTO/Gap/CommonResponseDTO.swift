//
//  CommonResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation

struct CommonResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EmptyResult?
}

struct EmptyResult: Decodable {}
