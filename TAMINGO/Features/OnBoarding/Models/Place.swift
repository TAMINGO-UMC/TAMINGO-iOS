//
//  Place.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import Foundation

// 마이페이지에서도 사용

struct Place : Identifiable{
    let id: UUID = UUID()

    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}


