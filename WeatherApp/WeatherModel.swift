//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by userext on 08/05/23.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let timelines: [Timeline]
}

// MARK: - Timeline
struct Timeline: Codable {
    let timestep: String
    let endTime, startTime: Date
    let intervals: [Interval]
}

// MARK: - Interval
struct Interval: Codable {
    let startTime: Date
    let values: Values
}

// MARK: - Values
struct Values: Codable {
    var weatherCode: Int
    let temperature: Double
}
