//
//  LocationManager.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/12/26.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()

    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestCurrentCoordinate() async throws -> CLLocationCoordinate2D {
        guard continuation == nil else {
            throw NSError(
                domain: "LocationManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "A location request is already in progress"]
            )
        }
        manager.requestWhenInUseAuthorization()
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coord = locations.last?.coordinate else { return }
        continuation?.resume(returning: coord)
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
