//
//  WeatherService.swift
//  Atmos
//
//  Created by Rodrigo Porto on 09/01/26.
//

import CoreLocation

protocol WeatherServiceProtocol {
    func fetchWeather(for location: CLLocation) async throws -> WeatherData
}

final class WeatherService: WeatherServiceProtocol {
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&current=temperature_2m,relative_humidity_2m,weathercode"
        
        guard let url = URL(string: urlString) else { throw WeatherError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
            return WeatherData(
                temperature: decoded.current.temperature_2m,
                condition: mapWeatherCode(decoded.current.weathercode),
                humidity: decoded.current.relative_humidity_2m
            )
        } catch {
            throw WeatherError.decodingError
        }
    }
    
    private func mapWeatherCode(_ code: Int) -> String {
        switch code {
        case 0:
            return "Clear"
        case 1:
            return "Mostly Clear"
        case 2:
            return "Partly Cloudy"
        case 3:
            return "Overcast"
        case 45, 48:
            return "Fog"
        case 51, 53, 55:
            return "Drizzle"
        case 56, 57:
            return "Freezing Drizzle"
        case 61, 63, 65:
            return "Rain"
        case 66, 67:
            return "Freezing Rain"
        case 71, 73, 75:
            return "Snow"
        case 77:
            return "Snow Grains"
        case 80, 81, 82:
            return "Rain Showers"
        case 85, 86:
            return "Snow Showers"
        case 95:
            return "Thunderstorm"
        case 96, 99:
            return "Thunderstorm with Hail"
        default:
            return "Unknown"
        }
    }
}
