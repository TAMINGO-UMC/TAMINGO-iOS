//
//  EditSchedule+Action.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import Foundation
import Moya

extension EditScheduleViewModel {
    // MARK: - Network: Get Schedule Detail
    @MainActor
    func loadSchedule(id: Int) async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            let response: BaseResponse<ScheduleResponseDTO> = try await provider.request(.getScheduleDetail(id: id))
            
            guard let result = response.result else { return }
            
            // 기본 정보 매핑
            self.scheduleId = result.scheduleId
            self.title = result.title
            self.memo = result.memo
            
            // 시간 정보 매핑
            let startString = "\(result.scheduleDate) \(result.startTime)"
            let endString = "\(result.scheduleDate) \(result.endTime)"
            
            if let start = startString.toDate(format: "yyyy-MM-dd HH:mm"),
               let end = endString.toDate(format: "yyyy-MM-dd HH:mm") {
                self.startTime = start
                self.endTime = end
            }
            
            // 장소 정보 매핑 (Optional -> String 변환)
            self.placeName = result.placeName ?? ""
            self.address = result.address ?? ""
            self.latitude = result.latitude
            self.longitude = result.longitude
            
            // 반복 설정 매핑
            if let type = RepeatType(rawValue: result.repeatType) {
                self.repeatType = type
            } else {
                self.repeatType = .none
            }
            
            // 반복 종료일
            if let endDateStr = result.repeatEndDate,
               let endDate = endDateStr.toDate(format: "yyyy-MM-dd") {
                self.repeatEndDate = endDate
                self.isEndDated = true
            } else {
                self.isEndDated = false
                self.repeatEndDate = Date()
            }
            
            // 할 일 리스트 매핑
            self.linkedTodos = result.linkedTodos
            self.candidateTodos = result.candidateTodos
            
            // 카테고리 매핑
            if let catName = result.category {
                self.categoryName = catName
                if let id = self.findCategoryId(by: catName) {
                    self.scheduleCategoryId = id
                }
            } else {
                self.categoryName = ""
                self.scheduleCategoryId = 0
            }
            
        } catch {
            print("일정 상세 조회 실패: \(error)")
        }
    }
    
    // MARK: - Network: Edit Schedule
    @MainActor
    func editSchedule() async -> Bool {
        self.isLoading = true
        defer { self.isLoading = false }
        
        // 날짜 및 시간 포맷팅
        let dateString = startTime.toString(format: "yyyy-MM-dd")
        let startTimeString = startTime.toString(format: "HH:mm")
        let endTimeString = endTime.toString(format: "HH:mm")
        
        // 반복 종료일 처리
        let repeatEndDateString: String? = (repeatType != .none && isEndDated)
        ? repeatEndDate.toString(format: "yyyy-MM-dd")
        : nil
        
        // 옵셔널 값 처리 (빈 값 -> nil)
        let categoryIdToSend: Int? = (scheduleCategoryId == 0) ? nil : scheduleCategoryId
        let placeNameToSend: String? = placeName.isEmpty ? nil : placeName
        let addressToSend: String? = address.isEmpty ? nil : address
        
        // 연동된 투두 ID 추출
        let linkedIds = linkedTodos.map { $0.todoId }
        
        // DTO 생성
        let dto = ScheduleEditDTO(
            title: title,
            scheduleDate: dateString,
            startTime: startTimeString,
            endTime: endTimeString,
            placeName: placeNameToSend,
            address: addressToSend,
            latitude: latitude,
            longitude: longitude,
            scheduleCategoryId: categoryIdToSend,
            memo: memo,
            repeatType: repeatType.rawValue,
            repeatEndDate: repeatEndDateString,
            linkedTodoIds: linkedIds
        )
        
        do {
            // API 요청
            let response: BaseResponse<String> = try await provider.request(.updateSchedule(id: self.scheduleId, body: dto))
            
            if response.isSuccess {
                print("일정 수정 성공")
                return true
            } else {
                print("일정 수정 실패: \(response.message)")
                return false
            }
            
        } catch {
            print("일정 수정 네트워크 에러: \(error)")
            return false
        }
    }
}
