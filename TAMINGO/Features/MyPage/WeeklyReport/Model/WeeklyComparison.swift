//
//  WeeklyComparison.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//

import Foundation

struct WeeklyComparisonMetric: Identifiable {
    let id = UUID()
    let title: String
    let previousValue: String
    let currentValue: String
    let diffValue: Int
}
