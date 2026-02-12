//
//  FrequentPlacesViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class FavoritePlacesViewModel {

    var places: [FavoritePlace] = []
    var editingPlace: FavoritePlace?

    var errorMessage: String?

    private let service: FavoritePlacesServiceProtocol

    init(
        service: FavoritePlacesServiceProtocol? = nil,
    ) {
        self.service = service ?? FavoritePlacesService()
    }

    // MARK: - View에서 호출

    func addPlace(_ place: Place) async {
        let request = PlaceRequestDTO(
            name: place.name,
            address: place.address,
            latitude: place.latitude,
            longitude: place.longitude
        )
        await addPlace(request: request)
    }

    func updatePlace(_ place: Place) async {

        guard let editingPlace else { return }

        let request = PlaceRequestDTO(
            name: place.name,
            address: place.address,
            latitude: place.latitude,
            longitude: place.longitude
        )

        await updatePlace(id: editingPlace.id, request: request)
    }

    func deletePlace(_ place: FavoritePlace) async {
        await deletePlace(id: place.id)
    }

    func editPlace(_ place: FavoritePlace) {
        editingPlace = place
    }

    
}

// 요청
extension FavoritePlacesViewModel {

    func fetchPlaces() async {
        errorMessage = nil
        do {
            let domainPlaces = try await service.fetchPlaces()
            self.places = domainPlaces
        } catch let error as APIError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "네트워크 오류가 발생했습니다."
        }
    }

    private func addPlace(request: PlaceRequestDTO) async {
        do {
            _ = try await service.createPlace(request)
            await fetchPlaces()
        } catch let error as APIError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "네트워크 오류가 발생했습니다."
        }
    }

    private func deletePlace(id: Int) async {
        do {
            _ = try await service.deletePlace(placeId: id)
            await fetchPlaces()
        } catch let error as APIError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "네트워크 오류가 발생했습니다."
        }
    }

    private func updatePlace(id: Int, request: PlaceRequestDTO) async {
        do {
            _ = try await service.updatePlace(placeId: id, dto: request)
            await fetchPlaces()
        } catch let error as APIError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "네트워크 오류가 발생했습니다."
        }
    }
}
