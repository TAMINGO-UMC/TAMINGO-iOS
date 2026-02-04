//
//  ScheduleCategory.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI

struct ScheduleCategory: Identifiable {
    let id: Int
    let name: String
    let color: Color
    let colorName: String
}

extension ScheduleCategory:CategoryItem{}
