//
//  PlaceSearchViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import Observation
import Foundation

@MainActor
@Observable
final class PlaceSearchViewModel {

    // MARK: - Step
    var step: PlaceSearchStep = .webSearch

    // MARK: - 검색
    var query: String = ""
    var results: [AddressDocument] = []
    var isLoading: Bool = false

    private var searchTask: Task<Void, Never>?

    // MARK: - 주소 정보
    var address: String = ""
    var jibunAddress: String = ""
    var zonecode: String = ""
    var latitude: Double?
    var longitude: Double?

    var placeName: String = ""

    // MARK: - 단계 확인
    var canProceed: Bool {
        step == .nameInput && !placeName.isEmpty
    }

    // MARK: - 검색
    func search() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            searchTask?.cancel()
            results = []
            isLoading = false
            return
        }

        // 이전 검색 취소
        searchTask?.cancel()
        isLoading = true

        searchTask = Task { [trimmed] in
            do {
                let docs = try await PlaceSearchService.shared.search(query: trimmed)

                // 최신 검색어가 아닐 경우 무시
                guard self.query == trimmed else { return }

                self.results = docs
                self.isLoading = false

            } catch is CancellationError {
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error)
            }
        }
    }

    // MARK: - 주소 선택 결과 반영
    func didSelectAddress(_ document: AddressDocument) {
        address = document.address_name
        latitude = Double(document.y)
        longitude = Double(document.x)
        step = .nameInput
    }

    // MARK: - Place 모델 생성
    func makePlace() -> Place? {
        guard
            canProceed,
            let latitude,
            let longitude
        else { return nil }

        return Place(
            name: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude
        )
    }

    // MARK: - 초기화
    func reset() {
        searchTask?.cancel()
        query = ""
        results = []
        address = ""
        jibunAddress = ""
        zonecode = ""
        latitude = nil
        longitude = nil
        placeName = ""
        step = .webSearch
    }
}
