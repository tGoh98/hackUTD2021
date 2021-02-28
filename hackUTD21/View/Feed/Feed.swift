//
//  Feed.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import SwiftUI
import MapKit

struct Feed: View {
    @EnvironmentObject var modelData: ModelData
    @State private var timeElapsed: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var action: Int? = 0
    
    
    var body: some View {
        
        ZStack {
            VStack() {
                Text("")
                    .font(.system(size: 1))
                    .onReceive(timer, perform: { _ in
                        timeElapsed += 1
                        if timeElapsed >= 3 {
                            self.timer.upstream.connect().cancel()
                        } else {
                            loadFeed(modelData: modelData)
                            //                            print(modelData.feed[0].name, modelData.feed[0].moments)
                        }
                        
                        
                    })
                NavigationView {
                    List(modelData.feed) { feedItem in
                        ZStack {
                            
                            FeedCard(name: feedItem.name, timeAdded: feedItem.timeAdded, desc: feedItem.desc, routeId: feedItem.routeId, moments: feedItem.moments, region: MKCoordinateRegion(center: feedItem.firstCoord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                            NavigationLink(
                                destination: TrailDetail(card: FeedCard(name: feedItem.name, timeAdded: feedItem.timeAdded, desc: feedItem.desc, routeId: feedItem.routeId, moments: feedItem.moments, region: MKCoordinateRegion(center: feedItem.firstCoord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))),
                                tag: 1,
                                selection: $action
                            ) {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onTapGesture {
                            self.action = 1
                            //                            modelData.showFAB = false
                            //                            print("showFAB is now false")
                        }
                    }
                    .navigationTitle("Home")
                }
            }
        }
    }
}

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        Feed()
            .environmentObject(ModelData())
    }
}
