//
//  SetupViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import Foundation

@Observable
final class SetupViewModel {

    // 활동 시간
    var startTime: Date = Date()
    var endTime: Date = Date()

    // 장소
    var places: [Place] = []

    var searchAddress: String = ""
    var placeName: String = ""

    let maxPlaces = 5

    // 장소 추가 가능 여부 확인
    var canAddPlace: Bool {
        !searchAddress.isEmpty &&
        !placeName.isEmpty &&
        places.count < maxPlaces
    }

    // 시작 시간, 종료 시간 적합성 확인
    var isEndTimeValid: Bool {
        endTime > startTime
    }
    
    // 이동 수단들
    var selectedTransports: [TransportType] = []
    
    // 역산 시간
    var arrivalBuffer: ArrivalBufferType = .ten
    
    // 모든 항목 작성했는지 여부
    var isValid: Bool {
        guard endTime > startTime else { return false }
//        guard !places.isEmpty && places.count <= 5 else { return false } // 조건 보류
        guard selectedTransports.count == TransportType.allCases.count else {
            return false
        }
        return true
    }
    
    // MARK: - 자주 가는 장소
    
    // 장소 검색 로직 추가 예정 //
    
    // 장소 추가
    func addPlace() {
        guard canAddPlace else { return }
        places.append(
            Place(address: searchAddress,
                  nickname: placeName)
        )
        clearInputs()
    }

    // 장소 삭제
    func removePlace(_ place: Place) {
        places.removeAll { $0.id == place.id }
    }

    // 입력창 초기화
    private func clearInputs() {
        searchAddress = ""
        placeName = ""
    }
    
    // MARK: - 선호 수단
    // 순서 조회
    func priority(of type: TransportType) -> Int? {
        guard let index = selectedTransports.firstIndex(of: type) else { return nil }
        return index + 1
    }
    
    // 선택되어있는지 검사
    func isSelected(_ type: TransportType) -> Bool {
        selectedTransports.contains(type)
    }
    
    func backgroundOpacity(for type: TransportType) -> Double {
        guard let priority = priority(of: type) else {
            return 0.3
        }

        switch priority {
        case 1: return 1.0
        case 2: return 0.7
        case 3: return 0.4
        default: return 0.4
        }
    }
    
    // 수단 선택/해제
    func toggle(_ type: TransportType) {
        if let index = selectedTransports.firstIndex(of: type) {
            selectedTransports.remove(at: index)
        } else {
            selectedTransports.append(type)
        }
    }
}

