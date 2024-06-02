//
//  ContentView.swift
//  WeatherDemo
//
//  Created by Li Wu on 5/29/24.
//
import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: WeatherResponse?
    @State var failedToFetch = false
    
    var body: some View {
        ZStack {
            Color(hue: 0.656, saturation: 0.787, brightness: 0.354)
                .ignoresSafeArea()
            
            if failedToFetch {
                failedToFetchView
            } else {
                contentView
            }
        }
        .preferredColorScheme(.dark)
    }
    
    var contentView: some View {
        VStack {
            if locationManager.location != nil {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    loadingView
                }
            } else {
                locationLoadingView
            }
        }
    }
    
    var failedToFetchView: some View {
        Text("Failed to Fetch the Weather Right now")
    }
    
   
    
    var loadingView: some View {
        LoadingView()
            .task {
                await fetchWeather()
            }
    }
    
    var locationLoadingView: some View {
        Group {
            if locationManager.isLoading {
                LoadingView()
            } else {
                WelcomeView()
                    .environmentObject(locationManager)
            }
        }
    }
    
    func fetchWeather() async {
        guard let location = locationManager.location else { return }
        
        do {
            weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
        } catch {
            print("Error getting weather: \(error)")
            failedToFetch = true
        }
    }
}

#Preview {
    ContentView()
}
