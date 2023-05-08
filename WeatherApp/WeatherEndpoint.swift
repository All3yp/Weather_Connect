//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by userext on 08/05/23.
//

import CoreLocation

struct WeatherEndpoint {
    let baseURL = "https://api.tomorrow.io/v4/timelines"
    let location: CLLocation
    let apiKey = "rGQBRaNgwSwHTignYBOXTOnCtG9pikn3"
    let startTime: String
    let endTime: String
    
    var url: URL? {
        let fields = ["temperature", "weatherCode"]
        let units = "metric"
        let timesteps = "1h"
        let urlString = "\(baseURL)?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&fields=\(fields.joined(separator: ","))&units=\(units)&timesteps=\(timesteps)&startTime=\(startTime)&endTime=\(endTime)&apikey=\(apiKey)"
        return URL(string: urlString)
    }
}
