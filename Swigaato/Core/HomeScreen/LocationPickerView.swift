//
//  LocationPickerView.swift
//  Swigaato
//
//  Created by MacMini6 on 25/02/25.
//


//import SwiftUI
//import CoreLocation
//
//struct LocationPickerView: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var locationManager: LocationManager
//    @State private var searchText = ""
//    
//    // Sample recent locations
//    let recentLocations = [
//        "Home: 123 Main St",
//        "Work: 456 Office Ave",
//        "Gym: 789 Fitness Blvd"
//    ]
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                // Current Location Button
//                Button(action: {
//                    locationManager.checkLocationAuthorization()
//                    dismiss()
//                }) {
//                    HStack {
//                        Image(systemName: "location.fill")
//                            .foregroundColor(.blue)
//                        Text("Use Current Location")
//                            .foregroundColor(.blue)
//                        Spacer()
//                        if locationManager.locationString == "Fetching location..." {
//                            ProgressView()
//                        }
//                    }
//                    .padding()
//                    .background(Color.blue.opacity(0.1))
//                    .cornerRadius(10)
//                }
//                
//                // Search Bar
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.gray)
//                    TextField("Search location", text: $searchText)
//                }
//                .padding()
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(10)
//                
//                // Recent Locations
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Recent Locations")
//                        .font(.headline)
//                    
//                    ForEach(recentLocations, id: \.self) { location in
//                        Button(action: {
//                            // Handle selecting recent location
//                            dismiss()
//                        }) {
//                            HStack {
//                                Image(systemName: "clock.fill")
//                                    .foregroundColor(.gray)
//                                Text(location)
//                                    .foregroundColor(.primary)
//                                Spacer()
//                            }
//                        }
//                        .padding(.vertical, 8)
//                        Divider()
//                    }
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("Select Location")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}
import SwiftUI
import CoreLocation

struct LocationPickerView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var locationManager: LocationManager
    @State private var searchText = ""
    
    // Sample recent locations
    let recentLocations = [
        "Home: 123 Main St",
        "Work: 456 Office Ave",
        "Gym: 789 Fitness Blvd"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Current Location Button
                Button(action: {
                    locationManager.checkLocationAuthorization()
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        Text("Use Current Location")
                            .foregroundColor(.blue)
                        Spacer()
                        if locationManager.locationString == "Fetching location..." {
                            ProgressView()
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search location", text: $searchText)
                        .onChange(of: searchText) { newValue in
                            locationManager.searchLocation(newValue)
                        }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                if !searchText.isEmpty && !locationManager.searchResults.isEmpty {
                    // Search Results
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Search Results")
                                .font(.headline)
                            
                            ForEach(locationManager.searchResults) { result in
                                LocationResultRow(result: result) {
                                    locationManager.selectLocation(result)
                                    dismiss()
                                }
                            }
                        }
                    }
                } else {
                    // Recent Locations
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Locations")
                            .font(.headline)
                        
                        if locationManager.recentLocations.isEmpty {
                            ForEach(recentLocations, id: \.self) { location in
                                Button(action: {
                                    // Handle selecting sample location
                                    let result = LocationResult(
                                        id: UUID(),
                                        name: location.components(separatedBy: ": ").first ?? "",
                                        address: location,
                                        location: CLLocation(latitude: 0, longitude: 0)
                                    )
                                    locationManager.selectLocation(result)
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "clock.fill")
                                            .foregroundColor(.gray)
                                        Text(location)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                                .padding(.vertical, 8)
                                Divider()
                            }
                        } else {
                            ForEach(locationManager.recentLocations) { result in
                                LocationResultRow(result: result) {
                                    locationManager.selectLocation(result)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LocationResultRow: View {
    let result: LocationResult
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.blue)
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.name)
                        .foregroundColor(.primary)
                    Text(result.address)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding(.vertical, 8)
        Divider()
    }
}
