//
//  WeeklyInsight.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//

import SwiftUI

struct WeeklyInsight: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let description: String
    let borderColor: Color
    let backgroundColor: Color
    let titleColor: Color
}
