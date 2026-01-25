//
//  ScheduleServiceProtocol.swift
//  TAMINGO
//
//  Created by 김도연 on 1/23/26.
//

import Foundation

protocol ScheduleServiceProtocol {
    func analyzeText(_ text: String) async throws -> AIAnalyzeResponse
    func saveSchedule(_ request: ScheduleSaveRequest) async throws -> Bool
}

class MockScheduleService: ScheduleServiceProtocol {
    
    // AI 추론 API (Mock)
    func analyzeText(_ text: String) async throws -> AIAnalyzeResponse {
        // 실제 API 호출하는 척
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        // 입력 텍스트에 따라 그럴싸한 결과 반환 (테스트용)
        let now = Date()
        
        if text.contains("팀플") {
            return AIAnalyzeResponse(
                title: text,
                place: "공학관 301호",
                category: "SCHOOL",
                startDateTime: now.addingTimeInterval(3600), // 1시간 뒤
                endDateTime: now.addingTimeInterval(7200)    // 2시간 뒤
            )
        } else if text.contains("알바") {
            return AIAnalyzeResponse(
                title: "편의점 알바",
                place: "GS25",
                category: "PARTTIMEJOB",
                startDateTime: now.addingTimeInterval(10000),
                endDateTime: now.addingTimeInterval(20000)
            )
        } else {
            // 기본값
            return AIAnalyzeResponse(
                title: text,
                place: "장소 미정",
                category: "CLUB",
                startDateTime: now,
                endDateTime: now.addingTimeInterval(3600)
            )
        }
    }
    
    // 2. 일정 저장 API (Mock)
    func saveSchedule(_ request: ScheduleSaveRequest) async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        print("✅ 서버 전송 성공: \(request)") // 콘솔에서 데이터 확인
        return true
    }
}
