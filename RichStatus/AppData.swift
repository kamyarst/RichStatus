//
//  AppData.swift
//  RichStatus
//
//  Created by Kamyar on 17/01/2023.
//

import Foundation

// MARK: - UserDefault

@propertyWrapper
struct UserDefault<T: Codable> {
    private let key: String
    private let defaultValue: T
    private var userDefault: UserDefaults

    init(key: String, defaultValue: T, userDefault: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefault = userDefault
    }

    var wrappedValue: T {
        get {
            guard let data = self.userDefault.object(forKey: key) as? Data else {
                return self.defaultValue
            }

            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? self.defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            self.userDefault.set(data, forKey: self.key)
        }
    }

}

// MARK: - AppData

enum AppData {

    @UserDefault(key: KeyType.featureWeather.stringValue, defaultValue: true)
    static var featureWeather: Bool

    @UserDefault(key: KeyType.featureTimer.stringValue, defaultValue: true)
    static var featureTimer: Bool
    
    @UserDefault(key: KeyType.timerRemaining.stringValue, defaultValue: 0)
    static var timerRemaining: TimeInterval
    
    @UserDefault(key: KeyType.timerHasAlert.stringValue, defaultValue: true)
    static var timerHasAlert: Bool

    enum KeyType: CodingKey {
        case featureWeather
        case featureTimer
        case timerRemaining
        case timerHasAlert
    }
}
