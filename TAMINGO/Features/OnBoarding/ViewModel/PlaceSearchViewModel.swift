//
//  PlaceSearchViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import Foundation
import CoreLocation

@Observable
final class PlaceSearchViewModel {

    var step: PlaceSearchStep = .webSearch

    var address: String = ""
    var jibunAddress: String = ""
    var zonecode: String = ""
    var placeName: String = ""

    var canProceed: Bool {
        step == .nameInput && !placeName.isEmpty
    }

    func didSelectAddress(_ result: AddressSearchResult) {
        self.address = result.roadAddress
        self.jibunAddress = result.jibunAddress
        self.zonecode = result.zonecode
        step = .nameInput
    }

    func makePlace(latitude: Double, longitude: Double) -> Place? {
        guard canProceed else { return nil }

        return Place(
            name: placeName,
            address: address,
            latitude: latitude,
            longitude: longitude
        )
    }
    
    

    func reset() {
        address = ""
        jibunAddress = ""
        zonecode = ""
        placeName = ""
        step = .webSearch
    }
}
