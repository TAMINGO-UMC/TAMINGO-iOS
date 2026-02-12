//
//  LocalTimeDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/10/26.
//

import Foundation

struct LocalTimeDTO: Decodable {
    let hour: Int
    let minute: Int
    let second: Int
    let nano: Int
}

extension LocalTimeDTO {
    var hhmm: String {
        String(format: "%02d:%02d", hour, minute)
    }
}
