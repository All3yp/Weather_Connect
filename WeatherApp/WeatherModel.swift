//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by userext on 08/05/23.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let data: WeatherData
}

// MARK: - DataClass
struct WeatherData: Codable {
    let timelines: [WeatherTimelines]
}

// MARK: - Timeline
struct WeatherTimelines: Codable {
    let intervals: [WeatherIntervals]
}

// MARK: - Interval
struct WeatherIntervals: Codable {
    let startTime: String
    let values: WeatherValue
}

// MARK: - Values
struct WeatherValue: Codable {
    var temperature: Double
    var weatherCode: Int
}
