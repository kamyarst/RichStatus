//
//  WeatherManager.swift
//  RichStatus
//
//  Created by Kamyar on 11/01/2023.
//

import Foundation
import WeatherKit

@MainActor class WeatherKitManager: ObservableObject {

    @Published var weather: Weather?

    func getWeather(latitude: Double, longitude: Double) async {
        do {
            self.weather = try await Task.detached(priority: .userInitiated) {
                try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            }.value
        } catch {
            fatalError("\(error)")
        }
    }

    var symbol: String {
        self.weather?.currentWeather.symbolName ?? "xmark.circle"
    }

    var temp: String {
        guard let temp = self.weather?.currentWeather.temperature else { return "Loading..." }

        let convert = Int(temp.value)
        return "\(convert)°"
    }
}
