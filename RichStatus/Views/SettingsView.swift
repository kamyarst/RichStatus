//
//  SettingsView.swift
//  RichStatus
//
//  Created by Kamyar on 08/01/2023.
//

import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {

    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.settings, id: \.id) { item in
                    NavigationLink {
                        item.view
                            .navigationTitle(item.title)
                    } label: {
                        Label(item.title, systemImage: item.image)
                            .symbolRenderingMode(.multicolor)
                    }
                }
            }
            .listStyle(.sidebar)
            Text("No selection")
        }
    }
}

// MARK: - Previews_SettingsView_Previews

struct Previews_SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

// MARK: - SettingsViewModel

final class SettingsViewModel: ObservableObject {

    @Published var settings: [SettingModel]
    @Published var selectedId: UUID?

    init(settings: [SettingModel] = SettingsViewModel.defaultSettings()) {
        self.settings = settings
        self.selectedId = settings.first?.id
    }

    static func defaultSettings() -> [SettingModel] {
        [.init(title: "Weather", image: "cloud.sun.fill", view: AnyView(WeatherSettingsView())),
         .init(title: "Timer", image: "timer", view: AnyView(TimerSettingsView()))]
    }
}

// MARK: - SettingModel

struct SettingModel: Identifiable {
    var id = UUID()
    var title: String
    var image: String
    var view: AnyView
}
