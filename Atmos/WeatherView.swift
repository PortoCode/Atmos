//
//  WeatherView.swift
//  Atmos
//
//  Created by Rodrigo Porto on 09/01/26.
//

import SwiftUI

struct WeatherView: View {
    @State private var viewModel = WeatherViewModel()
    @State private var city: String = "São Paulo"
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else if let weather = viewModel.weather {
                        WeatherCard(weather: weather)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Button("Update Weather") {
                        Task {
                            await viewModel.updateWeather(city: city)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .padding()
        }
        .navigationTitle("Atmos")
    }
}

struct WeatherCard: View {
    let weather: WeatherData
    
    var body: some View {
        VStack {
            Text("\(Int(weather.temperature))°C")
                .font(.system(size: 80, weight: .bold))
            Text(weather.condition)
                .font(.title2)
            HStack {
                Label("\(weather.humidity)%", systemImage: "humidity")
            }
        }
        .padding(40)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}
