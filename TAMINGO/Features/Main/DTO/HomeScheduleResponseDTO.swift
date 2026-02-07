//
//  ScheduleResponseDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/1/26.
//

import Foundation

// MARK: - Root Response
struct HomeScheduleResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: HomeScheduleResultDTO
}

// MARK: - Result
struct HomeScheduleResultDTO: Decodable {
    let date: String
    let items: [HomeScheduleItemDTO]
}
