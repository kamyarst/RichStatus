//
//  LocationManager.swift
//  RichStatus
//
//  Created by Kamyar on 11/01/2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    @Published var location = CLLocation()

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager auth status changed to:")
        switch status {
        case .restricted:
            print("status restricted")
        case .denied:
            print("status denied")

        case .authorized:
            print("status authorized")
            let location = self.locationManager.location
            print("location: \(String(describing: location))")

        case .notDetermined:
            print("status not yet determined")

        default:
            print("unknown state: \(status)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("location manager failed with error \(error)")
    }

    func getAddress(lat: Double, long: Double) async -> AddressEnum {

        var center = CLLocationCoordinate2D()
        center.latitude = lat
        center.longitude = long

        let ceo = CLGeocoder()
        let loc = CLLocation(latitude: center.latitude, longitude: center.longitude)

        let placeMark = (try? await ceo.reverseGeocodeLocation(loc))?.first
        guard let placeMark else { return .unknown }
        if let street = placeMark.thoroughfare ?? placeMark.subLocality, let city = placeMark.locality {
            return .streetCity(street + ", " + city)
        } else if let city = placeMark.locality {
            return .city(city)
        } else if let country = placeMark.country {
            return .country(country)
        } else {
            return .unknown
        }
    }

    enum AddressEnum {
        case city(String)
        case country(String)
        case streetCity(String)
        case unknown

        var string: String {
            switch self {
            case let .city(value): return value
            case let .country(value): return value
            case let .streetCity(value): return value
            case .unknown: return "Unknown"
            }
        }

        var image: String {
            switch self {
            case .unknown: return "location.slash"
            default: return "location"
            }
        }
    }
}
