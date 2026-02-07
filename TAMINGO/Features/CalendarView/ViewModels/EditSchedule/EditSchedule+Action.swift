//
//  File.swift
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
            
            // 장소 정보 매핑
            self.placeName = result.placeName
            self.address = result.address
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
                self.repeatEndDate = Date() // 토글 켜면 오늘부터 시작하도록 리셋
            }
            
            // 할 일 리스트 매핑
            self.linkedTodos = result.linkedTodos
            self.candidateTodos = result.candidateTodos
            
            // 카테고리 매핑
            self.categoryName = result.category
            // 카테고리 목록에서 이름이 일치하는 ID 찾기
            if let id = self.findCategoryId(by: result.category) {
                self.scheduleCategoryId = id
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
        
        // 연동된 투두 ID 추출
        let linkedIds = linkedTodos.map { $0.todoId }
        
        // DTO 생성
        let dto = ScheduleEditDTO(
            title: title,
            scheduleDate: dateString,
            startTime: startTimeString,
            endTime: endTimeString,
            placeName: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            scheduleCategoryId: scheduleCategoryId,
            memo: memo,
            repeatType: repeatType.rawValue,
            repeatEndDate: repeatEndDateString,
            linkedTodoIds: linkedIds
        )
        
        do {
            // API 요청
            let response: BaseResponse<String> = try await provider.request(.updateSchedule(id: self.scheduleId, body: dto))
            
            // 결과 처리
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
