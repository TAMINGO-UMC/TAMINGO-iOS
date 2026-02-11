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
        
        // 반복 종료일 처리 (NONE이면 무조건 nil)
        let repeatEndDateString: String?
        if repeatType == .none {
            repeatEndDateString = nil
        } else {
            repeatEndDateString = isEndDated ? repeatEndDate.toString(format: "yyyy-MM-dd") : nil
        }
        
        // 카테고리 ID 처리
        let categoryIdToSend: Int? = (scheduleCategoryId == 0) ? nil : scheduleCategoryId
        
        // 빈 문자열 처리 (빈 값이면 nil 전송)
        let placeNameToSend: String? = placeName.isEmpty ? nil : placeName
        let addressToSend: String? = address.isEmpty ? nil : address
        
        // AI 소스 처리 (내용 없으면 nil)
        let aiSourceToSend: AIInferenceSource?
        if aiInferenceSource.aiSuggestedPlaceName.isEmpty && aiInferenceSource.aiSuggestedCategoryName.isEmpty {
            aiSourceToSend = nil
        } else {
            aiSourceToSend = aiInferenceSource
        }
        
        let finalLinkedTodoIds = linkedTodos.map { $0.todoId }
        
        let requestDTO = ScheduleRequestDTO(
            title: title,
            scheduleDate: startTime.toString(format: "yyyy-MM-dd"),
            startTime: startTime.toString(format: "HH:mm"),
            endTime: endTime.toString(format: "HH:mm"),
            placeName: placeNameToSend,
            address: addressToSend,
            latitude: latitude,
            longitude: longitude,
            scheduleCategoryId: categoryIdToSend,
            memo: memo,
            repeatType: repeatType.rawValue,
            repeatEndDate: repeatEndDateString,
            linkedTodoIds: finalLinkedTodoIds,
            aiInferenceSource: aiSourceToSend
        )
        
        do {
            let _: BaseResponse<ScheduleCreationResponseDTO> = try await provider.request(.createSchedule(body: requestDTO))
            return true
        } catch {
            print("생성 실패: \(error)")
            return false
        }
    }
}
