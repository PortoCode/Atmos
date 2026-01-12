//
//  LocationManager.swift
//  Atmos
//
//  Created by Rodrigo Porto on 10/01/26.
//

import CoreLocation

enum LocationError: Error {
    case unauthorized
    case unableToDetermineLocation
}

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.authorizationStatus = manager.authorizationStatus
    }
    
    func checkPermission() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // The user denied it. Here the UI should show a link to Settings.
            break
        case .authorizedAlways, .authorizedWhenInUse:
            // Already allowed.
            break
        @unknown default:
            break
        }
    }
    
    func requestLocation() async throws -> CLLocation {
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationError.unableToDetermineLocation
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            manager.requestLocation()
        }
    }
    
    // MARK: - Delegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationContinuation?.resume(returning: location)
            locationContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
