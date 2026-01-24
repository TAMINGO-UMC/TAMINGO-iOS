//
//  RowSubContent.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI

enum RowSubContent {
    case count(Int)                 // 4개, 6개
    case status(Int, Color)      // 3개 연동됨
    case timeRange(String)          // 09:00 - 22:00
    case placeCount(Int)
    case summary([String])            // 버스 > 지하철 > 도보
    case comment(String, Color)
}
