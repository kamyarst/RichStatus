//
//  WeatherSettingsView.swift
//  RichStatus
//
//  Created by Kamyar on 18/01/2023.
//

import SwiftUI

struct WeatherSettingsView: View {

    @ObservedObject var locationManager = LocationManager()
    @State var isOn: Bool = AppData.featureWeather
    @State var cityName = LocationManager.AddressEnum.unknown

    var body: some View {
        List {
            Toggle("Show in Menu", isOn: $isOn)
                .toggleStyle(.switch)
            Divider()
            HStack {
                Text("Current Location")
                Spacer()
                Label("\(cityName.string)", systemImage: "location")
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.5), lineWidth: 1))
        .cornerRadius(8)
        .padding(16)
        .listStyle(.inset)
        .task {
            self.cityName = await locationManager.getAddress(lat: locationManager.lat,
                                                             long: locationManager.lon)
        }
    }
}
