//
//  WeatherViewModel.swift
//  Atmos
//
//  Created by Rodrigo Porto on 09/01/26.
//

import SwiftUI

@Observable
class WeatherViewModel {
    var weather: WeatherData?
    var isLoading = false
    var errorMessage: String?
    
    private let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }
    
    @MainActor
    func updateWeather(city: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.weather = try await service.fetchWeather(for: city)
        } catch {
            self.errorMessage = "Error loading data."
        }
        
        isLoading = false
    }
}
