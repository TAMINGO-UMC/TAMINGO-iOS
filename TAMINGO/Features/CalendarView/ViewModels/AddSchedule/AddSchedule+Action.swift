//
//  AddSchedule+Action.swift
//  TAMINGO
//
//  Created by 김도연 on 1/31/26.
//

import Foundation
import Moya

extension AddScheduleViewModel {
    
    // MARK: - Network: Create Schedule
    func createSchedule() async -> Bool {
        guard !title.isEmpty else { return false }
        
        // 반복 종료일 처리
        let repeatEndDateString: String? = (repeatType != .none && isEndDated) ? repeatEndDate.toString(format: "yyyy-MM-dd") : nil
        
        // 선택된 투두 객체들에서 ID 추출
        let finalLinkedTodoIds = linkedTodos.map { $0.todoId }
        
        let requestDTO = ScheduleRequestDTO(
            title: title,
            scheduleDate: startTime.toString(format: "yyyy-MM-dd"),
            startTime: startTime.toString(format: "HH:mm"),
            endTime: endTime.toString(format: "HH:mm"),
            placeName: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            scheduleCategoryId: scheduleCategoryId,
            memo: memo,
            repeatType: repeatType.rawValue,
            repeatEndDate: repeatEndDateString,
            linkedTodoIds: finalLinkedTodoIds,
            aiInferenceSource: aiInferenceSource
        )
        
        return await withCheckedContinuation { continuation in
            provider.request(.createSchedule(body: requestDTO)) { result in
                switch result {
                case .success(let response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        continuation.resume(returning: true)
                    } catch {
                        print("생성 실패 (Status Code): \(error)")
                        continuation.resume(returning: false)
                    }
                case .failure(let error):
                    print("생성 실패 (Network): \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
}
