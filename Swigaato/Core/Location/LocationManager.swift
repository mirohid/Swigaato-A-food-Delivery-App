import CoreLocation
import SwiftUI
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var currentLocation: CLLocation?
    @Published var locationString = "Select Location"
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var searchResults: [LocationResult] = []
    @Published var recentLocations: [LocationResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        DispatchQueue.main.async {
            self.authorizationStatus = self.locationManager.authorizationStatus
        }
    }
    
    func requestLocation() {
        isLoading = true
        errorMessage = nil
        locationString = "Fetching location..."
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            isLoading = false
            errorMessage = "Location access denied. Please enable in Settings."
            locationString = "Location access denied"
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
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
        errorMessage = nil
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        
        // Set the region to the current location if available, otherwise use world
        if let location = currentLocation {
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
                    self.errorMessage = "Search failed: \(error.localizedDescription)"
                    return
                }
                
                self.searchResults = response?.mapItems.compactMap { item in
                    guard let location = item.placemark.location else { return nil }
                    
                    let name = item.name ?? ""
                    var addressComponents: [String] = []
                    
                    if let thoroughfare = item.placemark.thoroughfare {
                        addressComponents.append(thoroughfare)
                    }
                    if let locality = item.placemark.locality {
                        addressComponents.append(locality)
                    }
                    if let administrativeArea = item.placemark.administrativeArea {
                        addressComponents.append(administrativeArea)
                    }
                    if let country = item.placemark.country {
                        addressComponents.append(country)
                    }
                    
                    let address = addressComponents.joined(separator: ", ")
                    
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
    
    func selectLocation(_ locationResult: LocationResult) {
        currentLocation = locationResult.location
        locationString = "\(locationResult.name), \(locationResult.address)"
        
        // Add to recent locations if not already present
        if !recentLocations.contains(where: { $0.id == locationResult.id }) {
            recentLocations.insert(locationResult, at: 0)
            if recentLocations.count > 5 {
                recentLocations.removeLast()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            if manager.authorizationStatus == .authorizedWhenInUse ||
                manager.authorizationStatus == .authorizedAlways {
                self.requestLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocation = location
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Geocoding failed: \(error.localizedDescription)"
                    self.locationString = "Location error"
                    return
                }
                
                if let placemark = placemarks?.first {
                    var addressComponents: [String] = []
                    
                    if let name = placemark.name {
                        addressComponents.append(name)
                    }
                    if let locality = placemark.locality {
                        addressComponents.append(locality)
                    }
                    if let administrativeArea = placemark.administrativeArea {
                        addressComponents.append(administrativeArea)
                    }
                    
                    self.locationString = addressComponents.joined(separator: ", ")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = "Location error: \(error.localizedDescription)"
            self.locationString = "Location error"
        }
    }
}

// MARK: - Location Result Model
struct LocationResult: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let location: CLLocation
} 