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
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var timerManager = TimerManager()
    @State var cityName = LocationManager.AddressEnum.unknown
    @State var timerState = TimerManager.TimerState.stoped

    var body: some Scene {
        WindowGroup {
            SettingsView()
        }

        setupWeatherIcon()
        setupTimerIcon()
    }

    private func setupWeatherIcon() -> MenuBarExtra<some View, some View> {

        MenuBarExtra {
            Button { } label: {
                Image(systemName: cityName.image)
                Text(cityName.string)
            }.disabled(true)

            Divider()
            Button("Settings", action: {
                NSApp.setActivationPolicy(.regular)
            })

            Button("Quit", action: {
                exit(-1)
            })

        } label: {
            HStack(spacing: 2) {
                Image(systemName: weatherKitManager.symbol)
                Text(weatherKitManager.temp)
            }
            .onAppear {
                NSApp.setActivationPolicy(.prohibited)
                Timer.scheduledTimer(withTimeInterval: 60 * 15, repeats: true) { _ in
                    Task {
                        await self.updateWeather()
                    }
                }
            }.task {
                await updateWeather()
            }
        }
    }

    private func updateWeather() async {
        self.cityName = await self.locationManager.getAddress(lat: self.locationManager.lat,
                                                              long: self.locationManager.lon)
        await self.weatherKitManager.getWeather(latitude: self.locationManager.lat,
                                                longitude: self.locationManager.lon)
    }

    private func setupTimerIcon() -> MenuBarExtra<some View, some View> {
        MenuBarExtra {
            if timerManager.timerStat == .stoped ||
                timerManager.timerStat == .paused {
                Button {
                    self.timerManager.startTimer()
                } label: {
                    Image(systemName: "play")
                    Text("Start")
                }
            }
            if timerManager.timerStat == .counting {
                Button {
                    self.timerManager.timerStat = .stoped
                    self.timerManager.timerString = "Timer"
                    AppData.timerRemaining = 0
                } label: {
                    Image(systemName: "stop")
                    Text("Stop")
                }
                Button {
                    self.timerManager.timerStat = .paused
                } label: {
                    Image(systemName: "pause")
                    Text("Pause")
                }
            }
            Button("Quit", action: {
                exit(-1)
            })

        } label: {
            HStack {
                Image(systemName: timerManager.timerStat.image)
                Text(timerManager.timerString)
            }
        }
    }
}
