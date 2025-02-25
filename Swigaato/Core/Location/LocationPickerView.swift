import SwiftUI
import CoreLocation
import MapKit

struct LocationPickerView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var locationManager: LocationManager
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Current Location Button
                Button(action: {
                    locationManager.requestLocation()
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        Text("Use Current Location")
                            .foregroundColor(.blue)
                        Spacer()
                        if locationManager.isLoading {
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
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: searchText) { newValue in
                            locationManager.searchLocation(newValue)
                        }
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                if locationManager.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    // Search Results
                    if !locationManager.searchResults.isEmpty {
                        LocationList(
                            title: "Search Results",
                            locations: locationManager.searchResults,
                            locationManager: locationManager,
                            dismiss: dismiss
                        )
                    }
                    // Recent Locations
                    else if !locationManager.recentLocations.isEmpty {
                        LocationList(
                            title: "Recent Locations",
                            locations: locationManager.recentLocations,
                            locationManager: locationManager,
                            dismiss: dismiss
                        )
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

struct LocationList: View {
    let title: String
    let locations: [LocationResult]
    let locationManager: LocationManager
    let dismiss: DismissAction
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .padding(.vertical, 5)
                
                ForEach(locations) { result in
                    LocationResultRow(result: result) {
                        locationManager.selectLocation(result)
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
            VStack(alignment: .leading, spacing: 4) {
                Text(result.name)
                    .font(.body)
                    .foregroundColor(.primary)
                Text(result.address)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
        }
        Divider()
    }
} 