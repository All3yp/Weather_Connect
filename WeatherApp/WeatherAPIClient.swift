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
        
        guard let url = URL(string: "https://api.tomorrow.io/v4/timelines?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&fields=temperature&fields=weatherCode&units=metric&timesteps=1h&startTime=\(dateFormatter.string(from: Date()))&endTime=\(dateFormatter.string(from: Date().addingTimeInterval(60 * 60)))&apikey=rGQBRaNgwSwHTignYBOXTOnCtG9pikn3") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(WeatherModel.self, from: data),
               let value = response.data.timelines.first?.intervals.first?.values,
               let weatherCode = WeatherCode(rawValue: "\(value.weatherCode)") {
                DispatchQueue.main.async { [weak self] in
                    self?.currentWeather = Weather(temperature: Int(value.temperature), weatherCode: weatherCode)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
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
