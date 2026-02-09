//
//  CategoryType.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

enum CategoryType {
    case todo
    case schedule

    var title: String {
        switch self {
        case .todo: return "할 일 카테고리"
        case .schedule: return "일정 카테고리"
        }
    }

    var description: String {
        switch self {
        case .todo:
            return "할일(To-do)에 사용되는 카테고리입니다"
        case .schedule:
            return "캘린더 일정에 사용되는 카테고리입니다"
        }
    }
}
