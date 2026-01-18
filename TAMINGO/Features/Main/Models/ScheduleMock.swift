//
//  ScheduleMock.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import Foundation

extension Schedule {

    static let mockToday: [Schedule] = [
        Schedule(
            title: "팀플 미팅",
            time: "09:40",
            location: "닷관 301 · 23분",
            remainingText: nil,
            isHighlighted: true
        ),
        Schedule(
            title: "도서반납",
            time: "12:30",
            location: "도서관 · 5–7분",
            remainingText: "10분 후",
            isHighlighted: false
        ),
        Schedule(
            title: "강의",
            time: "14:30",
            location: "공학관",
            remainingText: "56분 후",
            isHighlighted: false
        ),
        Schedule(
            title: "스터디",
            time: "16:30",
            location: "중앙도서관",
            remainingText: "3시간 후",
            isHighlighted: false
        )
    ]
}
