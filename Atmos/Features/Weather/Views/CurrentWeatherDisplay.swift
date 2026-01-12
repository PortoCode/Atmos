//
//  CurrentWeatherDisplay.swift
//  Atmos
//
//  Created by Rodrigo Porto on 11/01/26.
//

import SwiftUI

struct CurrentWeatherDisplay: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(Int(weather.temperature))°C")
                .font(.system(size: 70, weight: .thin))
            
            Text(weather.condition)
                .font(.title2)
                .foregroundStyle(.secondary)
            
            Text("Humidity: \(weather.humidity)%")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
