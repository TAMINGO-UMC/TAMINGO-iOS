//
//  MainTab.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

enum MainTab: CaseIterable {
    case home
    case calendar
    case todo
    case my

    var title: String {
        switch self {
        case .home: return "홈"
        case .calendar: return "캘린더"
        case .todo: return "할 일"
        case .my: return "마이"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .calendar: return "calendar"
        case .todo: return "checkmark.square"
        case .my: return "person"
        }
    }
}
