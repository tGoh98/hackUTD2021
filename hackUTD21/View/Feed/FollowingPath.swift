//
//  FollowingPath.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/28/21.
//

import SwiftUI
import MapKit
import FirebaseStorage

struct FollowingPath: View {
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var locationFetcher = LocationFetcher()
    @State private var momentCount: Int = 0
    @State private var timeElapsed: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var image = UIImage()
    //    @State var momentUUID: UUID = UUID()
    @State private var showMomentDialog: Bool = false
    @State private var routeMoments: Array<Moment> = [Moment]()
    //    @State private var isShowPhotoLibrary = false
    
    //    @State private var showingCreateMomentAlert = false
    //    @State private var trailBegan = false
    //    @State private var showVisibilityActionSheet = false
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
            
            ZStack {
                Map(
                    coordinateRegion: $region,
                    interactionModes: MapInteractionModes.all,
                    showsUserLocation: true,
                    userTrackingMode: $userTrackingMode,
                    annotationItems: routeMoments
                ) { moment in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: moment.latitude, longitude: moment.longitude))
                }
                
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            Image("recenterBtn")
                                .onTapGesture {
                                    centerMap()
                                }
                            Spacer()
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
                                                timeElapsed += 1
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
                                    // TODO: add in support for name and description input from user
                                    //                                    var uuid = modelData.requestIo.createRoute(currentUserUUID: modelData.currentUserUUID!, distanceTraveled: locationFetcher.trailDistance, timeElapsed: locationFetcher.calculateTimeTaken(), name: "name here!", description: "description here!")
                                    //                                    modelData.createdRouteId = uuid
                                    //                                    trailBegan = false
                                    //                                    locationFetcher.trailEndTime = DispatchTime.now()
                                    //                                    locationFetcher.trailStraightDistance = 0
                                    //                                    locationFetcher.trailDistance = 0
                                    //                                    self.timer.upstream.connect().cancel()
                                    //                                    modelData.pageNum = 2
                                    //                                    modelData.createMomentCount = momentCount
                                })
                                {
                                    Text("Finish")
                                        .fontWeight(.semibold)
                                        .font(.title3)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(.vertical, 7)
                                .foregroundColor(.white)
                                .background(Color.init(hex: "FE5722"))
                                .cornerRadius(40)
                                .padding(.horizontal, 20)
                                .padding(.bottom)
                            }
                            
                        }
                    }
                }
                if (self.showMomentDialog) {
                    Text("found momentdialog")
                }
                if locationFetcher.geofenceTriggered == true {
                    Menu("You Just Found A Moment!") {
                        Button("Check it Out", action: {
                            Image(systemName: "person.fill")
                                .data(url: URL(string: locationFetcher.imgSrc)!)
                                .scaledToFit()
                                .padding()
                            self.momentCount += 1
                            placeholder()
                        })
                    }
                }
            }
            .onAppear() {
                // getting moments
                self.routeMoments = self.modelData.requestIo.getMomentsForRoute(routeId: modelData.selectedRouteId)
                
                // creating geofences
                routeMoments.map { self.locationFetcher.monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), identifier: $0.id.uuidString) }
            }
        }
    }
    
    func placeholder() {
        locationFetcher.geofenceTriggered = false
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

struct FollowingPath_Previews: PreviewProvider {
    static var previews: some View {
        FollowingPath()
            .environmentObject(ModelData())
    }
}
