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
    @ObservedObject var locationFetcher = LocationFetcher()
    
    @State private var showingCreateMomentAlert = false
    @State private var trailBegan = false
    @State private var showVisibilityActionSheet = false
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 29.71097033151367, longitude:  -95.41502002886052),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    

    init() {
        self.locationFetcher.start()
        centerMap()
    }
    
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
            
            if locationFetcher.geofenceTriggered == true {
                Menu("You Just Found A Moment!") {
                    Button("Check it Out", action: placeholder)
                }

            }
            
            Button("Read Location") {
                centerMap()
            }
            
            Button("Create Moment") {
                if trailBegan == true {
                    createMoment()
                    DispatchQueue.global().asyncAfter(deadline: .now() +  .milliseconds(500)) {
                        let location = self.locationFetcher.lastKnownLocation!
                        self.region.center.latitude = location.latitude + 0.000001
                        self.region.center.latitude = location.latitude - 0.000001
                    }
                } else {
                    showingCreateMomentAlert = true
                }
            }
            .alert(isPresented: $showingCreateMomentAlert) {
                Alert(title: Text("Cannot Capture the Moment"), message: Text("Begin the trail to start capturing the moment!"), dismissButton: .default(Text("Got it!")))
            }
            
            Button("Begin Trail!") {
                trailBegan = true
                modelData.requestIo.trailMomentUUIDs = [UUID]()
                self.showVisibilityActionSheet = true
                locationFetcher.trailStartTime = DispatchTime.now()
            }
            .actionSheet(isPresented: $showVisibilityActionSheet) {
                ActionSheet(title: Text("Select Visibility"), message: Text("Choose a visibility for your new route."), buttons: [
                    .default(Text("Private")) {
                        var group = [UUID]()
                        group.append(modelData.currentUserUUID!)
                        modelData.requestIo.trailVisibility = Visibility(type: 0, groups: group) },
                    .default(Text("Public")) {
                        var group = [UUID]()
                        group.append(modelData.currentUserUUID!)
                        modelData.requestIo.trailVisibility = Visibility(type: 2, groups: group)},
                    .default(Text("Group")) {
                        var group = [UUID]()
                        group.append(modelData.currentUserUUID!)
                        modelData.requestIo.trailVisibility = Visibility(type: 1, groups: group)},
                    .cancel()
                ])
            }
            
            Button("End Trail!") {
                var uuid = modelData.requestIo.createRoute(currentUserUUID: modelData.currentUserUUID!)
                trailBegan = false
                locationFetcher.trailEndTime = DispatchTime.now()
            }
        }
    }
    

    
    func placeholder() {
        
    }
    
    func centerMap() {
        if let location = self.locationFetcher.lastKnownLocation {
            print("Your location is \(location)")
            self.region.center.latitude = location.latitude
            self.region.center.longitude = location.longitude
        } else {
            print("Your location is unknown")
        }
    }
    
    func createMoment() {
        if let location = self.locationFetcher.lastKnownLocation {
            var item = Item(strMsg: "new moment!")
            var uuid = modelData.requestIo.createMoment(contents: item, tags: ["tag1", "tag2"], coordinate: getCurrentLocation())
            
            
            // Add the moment UUID to trail moment array
            modelData.requestIo.trailMomentUUIDs.append(uuid)
            
        } else {
            print("Your location is unknown")
        }
    }
    func getCurrentLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: locationFetcher.lastKnownLocation?.latitude ?? 0.0,
            longitude: locationFetcher.lastKnownLocation?.longitude ?? 0.0)
    }
    
    func enteredFence() {
        Menu("options") {
        }
    }
    
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
