//
//  GeocodingService.swift
//  Atmos
//
//  Created by Rodrigo Porto on 16/01/26.
//

import CoreLocation

final class GeocodingService {
    private let geocoder = CLGeocoder()
    
    func fetchCity(from location: CLLocation) async throws -> String {
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first {
            return placemark.locality ?? placemark.subAdministrativeArea ?? "Unknown location"
        }
        return "Unknown location"
    }
}
