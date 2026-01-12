//
//  WeatherError.swift
//  Atmos
//
//  Created by Rodrigo Porto on 11/01/26.
//

import Foundation

enum WeatherError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The server URL is invalid."
        case .networkError(let error): return error.localizedDescription
        case .invalidResponse: return "The server returned an invalid response."
        case .decodingError: return "Failed to process weather data."
        }
    }
}
