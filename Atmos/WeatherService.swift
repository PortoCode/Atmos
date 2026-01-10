//
//  WeatherService.swift
//  Atmos
//
//  Created by Rodrigo Porto on 09/01/26.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherData
}

class WeatherService: WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherData {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return WeatherData(temperature: 24.5, condition: "Sunny", humidity: 60)
    }
}
