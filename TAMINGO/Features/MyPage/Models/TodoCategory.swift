//
//  TodoCategory.swift
//  TAMINGO
//
//  Created by 권예원 on 2/3/26.
//

import SwiftUI

struct TodoCategory: Identifiable {
    let id: Int
    let name: String
    let color: Color
    let colorName: String
}

extension TodoCategory:CategoryItem{}
