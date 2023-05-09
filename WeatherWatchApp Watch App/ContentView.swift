//
//  ContentView.swift
//  WeatherApp
//
//  Created by userext on 05/05/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var weatherAPIClient = WeatherAPIClient()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            if let currentWeather = weatherAPIClient.currentWeather {
                
                HStack(alignment: .center, spacing: 16) {
                    currentWeather.weatherCode.image
                        .font(.headline)
                    Text("\(currentWeather.temperature)º")
                        .font(.headline)
                }
                Text(currentWeather.weatherCode.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                
            } else {
                Text("No info available.\nTap to refresh.\nCheck location permissions.")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                Button("Refresh", action: {
                    Task {
                        await weatherAPIClient.fetchWeather()
                    }
                })
            }
            Spacer()
        }
        .onAppear {
            Task {
                await weatherAPIClient.fetchWeather()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
