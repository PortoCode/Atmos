//
//  WeatherData.swift
//  Atmos
//
//  Created by Rodrigo Porto on 09/01/26.
//

import Foundation

struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let temperature: Double
    let condition: String
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature
        case condition
        case humidity
    }
}
