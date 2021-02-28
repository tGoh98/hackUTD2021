//
//  MapView.swift
//  hackUTD21
//
//  Created by Seung Hun Jang on 2/27/21.
//

import SwiftUI
import MapKit


struct MapView: View {
    
    @EnvironmentObject var modelData: ModelData
    let locationFetcher = LocationFetcher()
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 29.71097033151367, longitude:  -95.41502002886052),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    

    
    var body: some View {
        
        VStack {
            Map(
                coordinateRegion: $region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: modelData.requestIo.moments
            ) { moment in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: moment.latitude, longitude: moment.longitude))
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
            Button("Create Moment") {
                if let location = self.locationFetcher.lastKnownLocation {
                    var item = Item(strMsg: "new moment!")
                    modelData.requestIo.createMoment(contents: item, tags: ["tag1", "tag2"], coordinate: getCurrentLocation())
                    print("Moment Created at \(location)")
                    
                    self.region.center.latitude = location.latitude + 0.000001
                    self.region.center.longitude = location.longitude + 0.00001
                    self.region.center.latitude = location.latitude - 0.000001
                    self.region.center.longitude = location.longitude - 0.00001
                    
                } else {
                    print("Your location is unknown")
                }
            }
        }
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: locationFetcher.lastKnownLocation?.latitude ?? 0.0,
            longitude: locationFetcher.lastKnownLocation?.longitude ?? 0.0)
    }
    

}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(ModelData())
    }
}
