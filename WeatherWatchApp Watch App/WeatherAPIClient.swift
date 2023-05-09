//
//  WeatherAPIClient.swift
//  WeatherApp
//
//  Created by userext on 08/05/23.
//

import SwiftUI
import CoreLocation

protocol WeatherAPIClientProtocol: AnyObject {
    func fetchWeather() async
    func requestLocation()
}

final class WeatherAPIClient: NSObject, ObservableObject, WeatherAPIClientProtocol {
    
    @Published var currentWeather: Weather?
    
    private let dateFormatter = ISO8601DateFormatter()
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestLocation()
    }
    
    func fetchWeather() async {
        guard let location = locationManager.location else {
            requestLocation()
            return
        }
        
        guard let url = WeatherEndpoint(
            location: location, startTime: dateFormatter.string(from: Date()),
            endTime: dateFormatter.string(from: Date().addingTimeInterval(60 * 60))).url else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Response data: \(String(data: data, encoding: .utf8) ?? "Empty data")")
            
            guard let response = try? JSONDecoder().decode(WeatherModel.self, from: data) else {
                print("Error decoding JSON response")
                return
            }
            
            guard let value = response.data.timelines.first?.intervals.first?.values else {
                print("Error parsing JSON response")
                return
            }
            
            guard let weatherCode = WeatherCode(rawValue: "\(String(describing: value.weatherCode))") else {
                print("Unknown weather code: \(String(describing: value.weatherCode))")
                return
            }
            
            updateCurrentWeather(temperature: value.temperature, weatherCode: weatherCode)
            
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
        }
    }
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func updateCurrentWeather(temperature: Double, weatherCode: WeatherCode) {
        DispatchQueue.main.async { [weak self] in
            self?.currentWeather = Weather(temperature: Int(temperature), weatherCode: weatherCode)
        }
    }
    
}

extension WeatherAPIClient: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { await fetchWeather() }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
