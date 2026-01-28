//
//  RepeatType.swift
//  TAMINGO
//
//  Created by 김도연 on 1/24/26.
//

enum RepeatType: String, Codable, CaseIterable {
    case none = "NONE"
    case daily = "DAILY"
    case weekly = "WEEKLY"
    case monthly = "MONTHLY"
    case yearly = "YEARLY"
    
    // 화면에 보여줄 한글 이름
    var title: String {
        switch self {
        case .none: return "없음"
        case .daily: return "매일"
        case .weekly: return "매주"
        case .monthly: return "매월"
        case .yearly: return "매년"
        }
    }
}
