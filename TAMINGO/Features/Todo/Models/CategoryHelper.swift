
//  CategoryHelper.swift
//  TAMINGO
//
//  Created by Claude on 2/10/26.
//  카테고리 색상 및 ID 매핑
//

import SwiftUI

/// 카테고리 관련 헬퍼 (색상, ID 매핑)
struct CategoryHelper {
    
    /// 카테고리 이름으로 Color 반환
    static func color(for categoryName: String) -> Color {
        switch categoryName {
        case "일상": return Color(hex: "#22C7A9")
        case "생활": return Color(hex: "#A7E0D8")
        case "업무": return Color(hex: "#FFC576")
        case "먹기": return Color(hex: "#FFD3B6")
        case "놀기": return Color(hex: "#FFC576")
        default: return Color(hex: "#22C7A9")  // 기본값
        }
    }
    
    /// 카테고리 이름으로 Category ID 반환 (서버 API용)
    static func id(for categoryName: String) -> Int {
        switch categoryName {
        case "일상": return 1
        case "생활": return 2
        case "업무": return 3
        case "먹기": return 4
        case "놀기": return 3  // 업무와 동일
        default: return 1
        }
    }
}
