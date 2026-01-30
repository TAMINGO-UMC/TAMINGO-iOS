//
//  BaseResponse.swift
//  TAMINGO
//
//  Created by 김도연 on 1/30/26.
//


struct BaseResponse<T: Decodable>: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
}
