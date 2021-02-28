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
    @Binding var started: Bool
    @State private var momentCount: Int = 0
    @State private var timeElapsed: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
    
    
    init(started: Binding<Bool>) {
        self._started = started
        self.locationFetcher.start()
        centerMap()
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                Map(
                    coordinateRegion: $region,
                    interactionModes: MapInteractionModes.all,
                    showsUserLocation: true,
                    userTrackingMode: $userTrackingMode,
                    annotationItems: modelData.requestIo.moments
                ) { moment in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: moment.latitude, longitude: moment.longitude))
                }
                
                VStack {
                    Spacer()
                    if (!started) {
                        Button (action: {
                            trailBegan = true
                            modelData.requestIo.trailMomentUUIDs = [UUID]()
                            self.showVisibilityActionSheet = true
                            locationFetcher.trailStartTime = DispatchTime.now()
                        })
                        {
                            Text("Let's go")
                                .fontWeight(.semibold)
                                .font(.title3)
                        }
                        .actionSheet(isPresented: $showVisibilityActionSheet) {
                            ActionSheet(title: Text("Select Visibility"), message: Text("Choose a visibility for your new route."), buttons: [
                                .default(Text("Private")) {
                                    var group = [UUID]()
                                    group.append(modelData.currentUserUUID!)
                                    modelData.requestIo.trailVisibility = Visibility(type: 0, groups: group)
                                    self.started.toggle()
                                },
                                .default(Text("Public")) {
                                    var group = [UUID]()
                                    group.append(modelData.currentUserUUID!)
                                    modelData.requestIo.trailVisibility = Visibility(type: 2, groups: group)
                                    self.started.toggle()
                                },
                                .default(Text("Group")) {
                                    var group = [UUID]()
                                    group.append(modelData.currentUserUUID!)
                                    modelData.requestIo.trailVisibility = Visibility(type: 1, groups: group)
                                    self.started.toggle()
                                },
                                .cancel()
                            ])
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .foregroundColor(.white)
                        .background(Color.init(hex: "FF7800"))
                        .cornerRadius(40)
                        .padding(.horizontal, 110)
                        .padding(.bottom, 60)
                    } else {
                        VStack {
                            HStack {
                                Image("recenterBtn")
                                    .onTapGesture {
                                        centerMap()
                                    }
                                Spacer()
                                Button(action: {
                                    if (trailBegan) {
                                        createMoment()
                                        DispatchQueue.global().asyncAfter(deadline: .now() +  .milliseconds(500)) {
                                            let location = self.locationFetcher.lastKnownLocation!
                                            self.region.center.latitude = location.latitude + 0.000001
                                            self.region.center.latitude = location.latitude - 0.000001
                                        }
                                    } else {
                                        showingCreateMomentAlert = true
                                    }
                                }) {
                                    Image("mapIcon")
                                }
                                .alert(isPresented: $showingCreateMomentAlert) {
                                    Alert(title: Text("Cannot Capture the Moment"), message: Text("Begin the trail to start capturing the moment!"), dismissButton: .default(Text("Got it!")))
                                }
                            }
                            .padding(.horizontal)
                            
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                VStack {
                                    HStack {
                                        VStack {
                                            Text("Distance")
                                            Text(String(format: "%.2f", locationFetcher.trailDistance))
                                                .font(.title)
                                        }
                                        .padding()
                                        Rectangle()
                                            .fill(Color.init(hex: "C4C4C4"))
                                            .frame(width: 1, height: 50)
                                        VStack {
                                            Text("Time")
                                            Text("\(getTimeStr(seconds: timeElapsed))")
                                                .onReceive(timer, perform: { _ in
                                                    if (started) {
                                                        timeElapsed += 1
                                                    }
                                                })
                                                .font(.title)
                                        }
                                        .padding()
                                        Rectangle()
                                            .fill(Color.init(hex: "C4C4C4"))
                                            .frame(width: 1, height: 50)
                                        VStack {
                                            Text("Moments")
                                            Text("\(momentCount)")
                                                .font(.title)
                                        }
                                        .padding()
                                    }
                                    
                                    Button (action: {
                                        var uuid = modelData.requestIo.createRoute(currentUserUUID: modelData.currentUserUUID!, distanceTraveled: locationFetcher.trailDistance, timeElapsed: locationFetcher.calculateTimeTaken())
                                        trailBegan = false
                                        locationFetcher.trailEndTime = DispatchTime.now()
                                        locationFetcher.trailStraightDistance = 0
                                        locationFetcher.trailDistance = 0
                                        self.timer.upstream.connect().cancel()
                                    })
                                    {
                                        Text("Finish")
                                            .fontWeight(.semibold)
                                            .font(.title3)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding(.vertical, 7)
                                    .foregroundColor(.white)
                                    .background(Color.init(hex: "FF7800"))
                                    .cornerRadius(40)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom)
                                }
                                
                            }
                        }
                        
                    }
                }
            }
            //            if locationFetcher.geofenceTriggered == true {
            //                Menu("You Just Found A Moment!") {
            //                    Button("Check it Out", action: placeholder)
            //                }
            //
            //            }
        }
    }

    func placeholder() {
        
    }
    
    func getTimeStr(seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        if (secs < 10) {
            return "\(mins):0\(secs)"
        }
        return "\(mins):\(secs)"
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
            
            momentCount += 1
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
        MapView(started: .constant(true))
            .environmentObject(ModelData())
    }
}
