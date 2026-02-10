//
//  Enum.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/10/26.
//

import Foundation
import SwiftUI

enum LineStyle {
    case none
    case dashed(Color)
    case solid(Color)
}

enum NodeStyle {
    case start(Color) // 시작원
    case end(Color)  // 도착원
    case walk(Color)

    // 지하철
    case subway(lineText: String, color: Color)

    // 버스는 그대로 아이콘
    case bus(Color)
}
