//
//  WeatherView.swift
//  Atmos
//
//  Created by Rodrigo Porto on 09/01/26.
//

import SwiftUI

struct WeatherView: View {
    @State private var viewModel = WeatherViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 25) {
                    contentView
                    Spacer()
                    actionButton
                }
                .padding()
            }
            .navigationTitle("Atmos")
            .preferredColorScheme(.dark)
            .alert(item: $viewModel.errorWrapper) { error in
                Alert(title: Text("Notice"), message: Text(error.message))
            }
            .onAppear {
                viewModel.checkInitialPermission()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    viewModel.checkInitialPermission()
                }
            }
        }
    }
    
    // MARK: - Dynamic Content
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.locationStatus {
        case .notDetermined:
            emptyStateView
            
        case .denied, .restricted:
            permissionDeniedView
            
        case .authorizedWhenInUse, .authorizedAlways:
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .controlSize(.large)
            } else if let weather = viewModel.weather {
                CurrentWeatherDisplay(weather: weather)
                    .transition(.push(from: .bottom))
            } else {
                emptyStateView
            }
            
        @unknown default:
            EmptyView()
        }
    }
    
    // MARK: - Button
    
    @ViewBuilder
    private var actionButton: some View {
        switch viewModel.locationStatus {
        case .denied, .restricted:
            Button {
                viewModel.openAppSettings()
            } label: {
                Label("Open Settings", systemImage: "gear")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            
        default:
            Button {
                viewModel.fetchLocalWeather()
            } label: {
                Label("Update Location", systemImage: "location.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)
        }
    }
    
    // MARK: - UI Pieces
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.blue.opacity(0.8), .black.opacity(0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            "Ready to Check?",
            systemImage: "location.circle",
            description: Text("Tap below to find out the weather at your current location.")
        )
    }
    
    private var permissionDeniedView: some View {
        ContentUnavailableView {
            Label("Location Disabled", systemImage: "location.slash.fill")
        } description: {
            Text("Please enable location access in Settings to get local weather.")
        }
    }
}
