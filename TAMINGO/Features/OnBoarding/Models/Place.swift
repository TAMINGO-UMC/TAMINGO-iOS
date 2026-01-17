//
//  Place.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import Foundation

struct Place: Identifiable,Equatable {
    let id = UUID()
    let address: String
    let nickname: String  
}
