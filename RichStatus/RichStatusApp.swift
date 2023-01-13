//
//  RichStatusApp.swift
//  RichStatus
//
//  Created by Kamyar on 08/01/2023.
//

import SwiftUI

@main
struct RichStatusApp: App {

    @ObservedObject var weatherKitManager = WeatherKitManager()
    @StateObject var locationDataManager = LocationDataManager()
    @State var cityName = LocationDataManager.AddressEnum.unknown
    var body: some Scene {
        setupWeatherIcon()
    private func setupWeatherIcon() -> MenuBarExtra<some View, Button<Text>> {
        MenuBarExtra {
            Button("Quit", action: {
                exit(-1)
            })
        } label: {
            HStack {
                Image(systemName: weatherKitManager.symbol)
                Text(weatherKitManager.temp)
            }
            .onAppear {
                NSApp.setActivationPolicy(.prohibited)
                Timer.scheduledTimer(withTimeInterval: 60 * 15, repeats: true) { _ in
                    Task {
//                        await weatherKitManager.getWeather(latitude: 52.49081, longitude: 1.88934)
                    }
                }
            }.task {
//                await weatherKitManager.getWeather(latitude: 52.49081, longitude: 1.88934)
            }
        }
    }
}
