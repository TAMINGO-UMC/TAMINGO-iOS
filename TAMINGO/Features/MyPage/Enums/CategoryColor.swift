//
//  CategoryColor.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//

import SwiftUI

// 변경 필요
enum CategoryColor: String, CaseIterable, Codable {
    case mint = "#22C7A9"
    case pink = "#FF8FAB"
    case purple = "#903ACD"
    case peach = "#FFC576"
    case lightMint = "#A8E6CF"
    case lightPeach = "#FFD3B6"
    case lightPurple = "#B4A7D6"
    case lightBlue = "#A7C3E7"
    case lightYellow = "#F9E79F"
    case coral = "#FF8B94"

    // 서버 전달용
    var hexCode: String {
        rawValue
    }

    // UI 표시용
    var displayName: String {
        switch self {
        case .mint: return "민트"
        case .pink: return "핑크"
        case .purple: return "퍼플"
        case .peach: return "피치"
        case .lightMint: return "연민트"
        case .lightPeach: return "연피치"
        case .lightPurple: return "연퍼플"
        case .lightBlue: return "연하늘"
        case .lightYellow: return "연노랑"
        case .coral: return "코랄"
        }
    }
    
    var color: Color {
        Color(hex: hexCode)
    }
}
