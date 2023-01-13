//
//  LocationDataManager.swift
//  RichStatus
//
//  Created by Kamyar on 11/01/2023.
//

import Foundation
import CoreLocation

class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?

    var latitude: Double {
        self.locationManager.location?.coordinate.latitude ?? 0.0
    }

    var longitude: Double {
        locationManager.location?.coordinate.longitude ?? 0.0
    }

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            self.authorizationStatus = .authorizedAlways
            self.locationManager.requestLocation()

        case .restricted: // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            self.authorizationStatus = .restricted

        case .denied: // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            self.authorizationStatus = .denied

        case .notDetermined: // Authorization not determined yet.
            self.authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()

        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
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
                case let .country(value):return value
                case let .streetCity(value):return value
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
