//
//  WeatherViewModel.swift
//  Atmos
//
//  Created by Rodrigo Porto on 09/01/26.
//

import SwiftUI
import CoreLocation

@Observable
@MainActor
class WeatherViewModel {
    var weather: WeatherData?
    var city: String?
    var isLoading = false
    var errorWrapper: ErrorWrapper?
    
    var locationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    private let locationManager = LocationManager()
    private let weatherService: WeatherServiceProtocol
    private let geocodingService = GeocodingService()
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = service
    }
    
    func checkInitialPermission() {
        locationManager.checkPermission()
    }
    
    func fetchLocalWeather() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let location = try await locationManager.requestLocation()
                
                async let weather = weatherService.fetchWeather(for: location)
                async let city = geocodingService.fetchCity(from: location)
                
                self.weather = try await weather
                self.city = try await city
            } catch {
                handleError(error)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let clError = error as? CLError, clError.code == .denied {
            errorWrapper = ErrorWrapper(message: "Location access denied. Enable in Settings.")
        } else {
            errorWrapper = ErrorWrapper(message: error.localizedDescription)
        }
    }
    
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
