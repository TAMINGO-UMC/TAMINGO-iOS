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

    // 시간 선택 여부
    var didSelectStartTime: Bool = false
    var didSelectEndTime: Bool = false

    // 장소
    var places: [Place] = []
    let maxPlaces = 5

    // 장소 추가 가능 여부 확인
    var canAddPlace: Bool {
        places.count < maxPlaces
    }
    

    // 시작 시간, 종료 시간 적합성 확인 : 시작 시간 < 종료 시간
    var isEndTimeValid: Bool {
        endTime > startTime
    }
    
    // 순위별 이동수단
    var transportRanks: [Int: TransportType] = [:]

    
    // 역산 시간
    var arrivalBuffer: ArrivalBufferType = .ten
    
    // 모든 항목 작성했는지 여부
    var isValid: Bool {
        guard didSelectStartTime,
              didSelectEndTime,
              endTime > startTime
        else {
            return false
        }

        guard transportRanks.count == 3,
              !transportRanks.values.contains(.none)
        else {
            return false
        }

        return true
    }

    
    // MARK: - 자주 가는 장소

    func addPlace(_ place: Place) {
        guard places.count < maxPlaces else { return }
        places.append(place)
    }
    func removePlace(_ place: Place) {
        places.removeAll { $0.id == place.id }
    }

    
    // MARK: - 선호 수단
    // 순서 조회
    func transport(for rank: Int) -> TransportType? {
        transportRanks[rank]
    }

    // 선택된 수단 
    func isTransportSelected(_ type: TransportType, excluding rank: Int) -> Bool {
        transportRanks
            .filter { $0.key != rank }
            .contains { $0.value == type }
    }
    
    // 수단 선택/해제
    func updateTransport(_ type: TransportType, for rank: Int) {
        guard !isTransportSelected(type, excluding: rank) else { return }
        guard transportRanks[rank] != type else { return }
        transportRanks[rank] = type
    }
    

}

