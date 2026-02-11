//
//  CategoryAPIErrorResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//


struct CategoryAPIErrorResponseDTO: Decodable {
    let isSuccess: Bool?
    let code: String?
    let message: String
}
