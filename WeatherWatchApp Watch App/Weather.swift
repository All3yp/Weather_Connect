//
//  Weather.swift
//  WeatherApp
//
//  Created by userext on 08/05/23.
//

import SwiftUI

struct Weather: Identifiable {
    let id = UUID()
    let temperature: Int
    let weatherCode: WeatherCode
}
