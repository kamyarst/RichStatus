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

}
