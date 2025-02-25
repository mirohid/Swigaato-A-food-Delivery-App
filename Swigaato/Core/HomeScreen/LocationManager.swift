//
//  LocationManager.swift
//  Swigaato
//
//  Created by MacMini6 on 25/02/25.
//


//import CoreLocation
//import SwiftUI
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    @Published var location: CLLocation?
//    @Published var locationString = "Fetching location..."
//    @Published var authorizationStatus: CLAuthorizationStatus?
//    @Published var lastKnownLocation: String = "New York, NY"
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 100 // Update location when user moves 100 meters
//        checkLocationAuthorization()
//    }
//    
//    func checkLocationAuthorization() {
//        switch locationManager.authorizationStatus {
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.startUpdatingLocation()
//        case .denied, .restricted:
//            // Handle denied access
//            break
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        @unknown default:
//            break
//        }
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
//        checkLocationAuthorization()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        self.location = location
//        
//        // Convert location to address
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Geocoding error: \(error.localizedDescription)")
//                return
//            }
//            
//            if let placemark = placemarks?.first {
//                let city = placemark.locality ?? ""
//                let state = placemark.administrativeArea ?? ""
//                self.locationString = "\(city), \(state)"
//                self.lastKnownLocation = self.locationString
//            }
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location error: \(error.localizedDescription)")
//    }
//}
import CoreLocation
import SwiftUI
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var location: CLLocation?
    @Published var locationString = "Select Location"
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var lastKnownLocation: String = "New York, NY"
    @Published var isLoading = false
    @Published var searchResults: [LocationResult] = []
    @Published var recentLocations: [LocationResult] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        isLoading = true
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            locationString = "Location access denied"
            isLoading = false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func searchLocation(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        
        if let location = location {
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
            searchRequest.region = region
        }
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    print("Search error: \(error.localizedDescription)")
                    return
                }
                
                self.searchResults = response?.mapItems.compactMap { item in
                    guard let location = item.placemark.location else { return nil }
                    
                    let name = item.name ?? ""
                    let address = [
                        item.placemark.thoroughfare,
                        item.placemark.locality,
                        item.placemark.administrativeArea,
                        item.placemark.country
                    ].compactMap { $0 }.joined(separator: ", ")
                    
                    return LocationResult(
                        id: UUID(),
                        name: name,
                        address: address,
                        location: location
                    )
                } ?? []
            }
        }
    }
    
    func selectLocation(_ result: LocationResult) {
        location = result.location
        locationString = "\(result.name), \(result.address)"
        
        if !recentLocations.contains(where: { $0.id == result.id }) {
            recentLocations.insert(result, at: 0)
            if recentLocations.count > 5 {
                recentLocations.removeLast()
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            self.checkLocationAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let state = placemark.administrativeArea ?? ""
                    self.locationString = "\(city), \(state)"
                    self.lastKnownLocation = self.locationString
                    
                    // Add current location to recent locations
                    let result = LocationResult(
                        id: UUID(),
                        name: "Current Location",
                        address: self.locationString,
                        location: location
                    )
                    self.selectLocation(result)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            print("Location error: \(error.localizedDescription)")
            self.isLoading = false
            self.locationString = "Location error"
        }
    }
}

struct LocationResult: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let location: CLLocation
}
