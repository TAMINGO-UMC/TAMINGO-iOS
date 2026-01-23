//
//  ScheduleCategory.swift
//  TAMINGO
//
//  Created by 김도연 on 1/23/26.
//

import SwiftUI

enum ScheduleCategory: String, Codable, CaseIterable {
    case school = "SCHOOL"
    case club = "CLUB"
    case partTimeJob = "PARTTIMEJOB"
    
    // 화면에 보여줄 한글 이름
    var title: String {
        switch self {
        case .school: return "학교"
        case .club: return "동아리"
        case .partTimeJob: return "알바"
        }
    }
    
    // 카테고리별 색상
    var color: Color {
        switch self {
        case .school: return .mainMint
        case .club: return .mainPink
        case .partTimeJob: return .yellow
        }
    }
}
