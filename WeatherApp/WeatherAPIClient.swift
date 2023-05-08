//
//  WeatherAPIClient.swift
//  WeatherApp
//
//  Created by userext on 08/05/23.
//

import Foundation
import CoreLocation

protocol WeatherAPIClientProtocol: AnyObject {
    func fetchWeather() async
    func requestLocation()
}

final class WeatherAPIClient: NSObject, WeatherAPIClientProtocol {
    
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
            let response = try JSONDecoder().decode(WeatherModel.self, from: data)
            if let value = response.data.timelines.first?.intervals.first?.values {
                if let temperature = value.temperature,
                   let weatherCodeString = value.weatherCode,
                   let weatherCode = WeatherCode(rawValue: "\(weatherCodeString)") {
                    updateCurrentWeather(temperature: temperature, weatherCode: weatherCode)
                } else {
                    print("Missing weather data")
                }
            } else {
                print("Missing weather data")
            }
        } catch {
            print(error.localizedDescription)
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
