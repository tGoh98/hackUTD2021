//
//  MapView.swift
//  hackUTD21
//
//  Created by Seung Hun Jang on 2/27/21.
//

import SwiftUI
import MapKit
import FirebaseStorage


struct MapView: View {
    
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var locationFetcher = LocationFetcher()
    @Binding var started: Bool
    @State private var momentCount: Int = 0
    @State private var timeElapsed: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var image = UIImage()
    @State var momentUUID: UUID = UUID()
    @State private var showMomentDialog: Bool = false
    @State private var isShowPhotoLibrary = false
    @State private var isShowMomentInput = false
    @State private var curMoments: Array<Moment> = [Moment]()
    @State private var caption: String = ""
    
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
                    annotationItems: self.curMoments
                )
                { moment in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: moment.latitude, longitude: moment.longitude))
                }
//                Map(
//                    coordinateRegion: $region,
//                    interactionModes: MapInteractionModes.all,
//                    showsUserLocation: true,
//                    userTrackingMode: $userTrackingMode
//                )
                
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
                        .background(Color.init(hex: "FE5722"))
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
                                        self.isShowMomentInput = true

                                        self.showMomentDialog = true
                                        
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
                                        // TODO: add in support for name and description input from user
                                        var uuid = modelData.requestIo.createRoute(currentUserUUID: modelData.currentUserUUID!, distanceTraveled: locationFetcher.trailDistance, timeElapsed: locationFetcher.calculateTimeTaken(), name: names.randomElement() ?? "Christina", description: descriptions.randomElement() ?? "Lets have pasta!")
                                        modelData.createdRouteId = uuid
                                        trailBegan = false
                                        locationFetcher.trailEndTime = DispatchTime.now()
                                        locationFetcher.trailStraightDistance = 0
                                        locationFetcher.trailDistance = 0
                                        self.timer.upstream.connect().cancel()
                                        modelData.pageNum = 2
                                        modelData.createMomentCount = momentCount
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
                }
                if (self.showMomentDialog) {
                    MyMoment(showMomentDialog: $showMomentDialog, image: $image, momentUUID: $momentUUID)
                }
                if (self.isShowMomentInput) {
                    VStack {
                            HStack {
                                Text("What message would you like to leave at this moment?")
                                    .font(.title2)
                                    .padding(.horizontal)
                                    .padding(.top)
                                Spacer()
                            }
                        TextField("Such a beautiful sunset!", text: $caption)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button(action: {
                            self.isShowPhotoLibrary.toggle()
                            self.isShowMomentInput.toggle()
                        }) {
                            Image(systemName:"camera")
                        }
                        .padding(.bottom)
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .shadow(radius: 1)
                    .padding()
                    
                }
            }
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
                .edgesIgnoringSafeArea(.all)
        }
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
            var item = Item(strMsg: caption)
            let newMoment: Moment = modelData.requestIo.createMoment(contents: item, tags: ["tag1", "tag2"], coordinate: getCurrentLocation())
            
            momentUUID = newMoment.id
            
            momentCount += 1
            // Add the moment UUID to trail moment array
            modelData.requestIo.trailMomentUUIDs.append(momentUUID)
            self.curMoments.append(newMoment)

            
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





let words = [
    "Sadie Klein",
    "Put some lipstick on, perfume your neck and slip your high heels on, rinse and curl your hair, loosen your hips and get a dress to wear.",
    
    "Gerardo Mora",
    "We need not only a purpose in life to give meaning to our existence but also something to give meaning to our suffering. We need as much something to suffer for as something to live for.",
    
    "Nickolas Norman",
    "They say: Do what you love and the money will come to you. Just ordered pizza, now I am waiting…",
    
    "Donovan Flynn",
    "Life is an unfoldment, and the further we travel the more truth we can comprehend. To understand the things that are at our door is the best preparation for understanding those that lie beyond.",
    
    "Peter Knapp",
    "Progress is impossible without change, and those who cannot change their minds cannot change anything.",
    
    "Kimberly Bean",
    "No place is boring if you’ve had a good night’s sleep and have a pocket of unexposed film.",
    
    "Yoselin Benson",
    "I always wonder why birds stay in the same place when they can fly anywhere on earth. Then I ask myself the same question.",
    
    "Maddox Burnett",
    "The use of traveling is to regulate imagination by reality, and instead of thinking how things may be, to see them as they are",
    
    "Antoine Hurley",
    "Because in the end, you won’t remember the time you spent in the office or mowing your lawn. Climb that goddamn mountain.",
    
    "Kaden Evans",
    "Travel is more than seeing sights; It is a change that goes on, deep and permanent, In the ideas of living",
    
    "Larry Franco",
    "Look for something positive in each day. Even if some days you have to look a little harder.",
    
    "Ayanna Warner",
    "People will forget what you said. People will forget what you did, but people will never forget how you made them feel.",
    
    "Yusuf Grimes",
    "You can’t go back and change the beginning, but you can start where you are and change the ending.",
    
    "Hamza Shaffer",
    "Your life is a result of your choices. If you don’t like your life, it’s time to make some better choices.",
    
    "Asia Abbott",
    "Sometimes the smallest step in the right direction ends up being the biggest step of your life. Tiptoe if you must, but take the step.",
    
    "Anahi Hart",
    "Do appreciate where you are in your journey. Even if it’s not where you want to be. Every season serves a purpose.",
    
    "Gordon Graham",
    "Push yourself because nobody is going to do it for you.",
    
    "Bryson Mccarty",
    "When you are the bottom, they laugh about you. When you are on the top, they are jealous. You cannot please everybody, So stop trying and focus.",
    
    "Jenny Matthews",
    "Nothing is IMPOSSIBLE. The word itself says, “I’M POSSIBLE.",
    
    "Kimberly Spence",
    "You can pack for every occasion, but a good friend will always be the best thing you could bring!",
    
    "Dalton Mitchell",
    "1 universe, 9 planets, 204 countries, 809 islands, 7 seas. And I had the privilege of meeting you.",
    
    "Dayton Michael",
    "The alphabet begins with ABC, numbers begin with 123, music begins with do-re-mi, and friendship begins with you and me.",
    
    "Angelo Parker",
    "The strong bond of friendship is not always a balanced equation; friendship is not always about giving and taking in equal shares. Instead, friendship is grounded in a feeling that you know exactly who will be there for you when you need something, no matter what or when.",
    
    "Angelica Norris",
    "I am thankful for the nights that turned into mornings, friends that turned into family, and dreams that turned into reality.",
    
    "Tripp Patton",
    "Making a million friends is not a miracle. The miracle is to make a friend who will stand by you when millions are against you.",
    
    "Ethan Odonnell",
    "That awkward moment when you’re wearing Nike’s and you can’t do it.",
    
    "Celia Buckley",
    "I finally realized that people are prisoners of their phones. That’s why it’s called a “Cell” Phone.",
    
    "Shamar Howell",
    "I haven’t worn these pants since I bought them. I should definitely pack them for my 3 days trip just in case.",
    
    "Collin Perry",
    "Remember, we all stumble, every one of us. That’s why it’s a comfort to go hand in hand.",
    
    "Alicia Hendricks",
    "You don’t find love, love finds you. It’s got a little bit to do with destiny, fate, and what’s written in the stars."
    
    
    
]


let names = stride(from: 0, to: words.count, by: 2).map { words[$0] }
let descriptions = stride(from: 1, to: words.count, by: 2).map { words[$0] }
