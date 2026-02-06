//
//  WeeklyMetric.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI

struct WeeklyMetric: Identifiable {
    let id = UUID()
    
    let title: String          // 정시 도착률
    let value: String          // "92%"
    let subValue: String      // "+5% 상승" / "17/20개" / "우수"
    
    let iconName: String       // 아이콘 이름
    let textColor: Color
    let backgroundColor: Color
}
