//
//  MapView.swift
//  hackUTD21
//
//  Created by Seung Hun Jang on 2/27/21.
//

import SwiftUI
import MapKit

struct City: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    let locationFetcher = LocationFetcher()
    
    @State private var cities: [City] = [
        City(coordinate: .init(latitude: 40.7128, longitude: -74.0060)),
        City(coordinate: .init(latitude: 37.7749, longitude: 122.4194)),
        City(coordinate: .init(latitude: 47.6062, longitude: 122.3321))
    ]
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(
            latitudeDelta: 10,
            longitudeDelta: 10
        )
    )
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: cities
            ) { city in
                MapMarker(coordinate: city.coordinate)
            }
            Button("Start Tracking Location") {
                self.locationFetcher.start()
            }
            Button("Read Location") {
                if let location = self.locationFetcher.lastKnownLocation {
                    print("Your location is \(location)")
                    self.region.center.latitude = location.latitude
                    self.region.center.longitude = location.longitude
                } else {
                    print("Your location is unknown")
                }
            }
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
