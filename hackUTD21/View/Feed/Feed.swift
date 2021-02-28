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
    
    var body: some View {
        ZStack {
            VStack() {
                NavigationView {
                    List(modelData.feed) { feedItem in
                        ZStack {
                            FeedCard(name: feedItem.name, timeAdded: feedItem.timeAdded, desc: feedItem.desc, region: MKCoordinateRegion(center: feedItem.firstCoord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                            NavigationLink(destination: TrailDetail(card: FeedCard(name: feedItem.name, timeAdded: feedItem.timeAdded, desc: feedItem.desc, region: MKCoordinateRegion(center: feedItem.firstCoord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))) {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .navigationTitle("Home")
                }
            }
            
            VStack() {
                Spacer()
                HStack() {
                    Button(action: {
                        modelData.pageNum = 2
                    }, label: {
                        Text("map view")
                    })
                    Spacer()
                    Button(action: {
                        modelData.pageNum = 1
                    }, label: {
                        Text("+")
                            .font(.system(.largeTitle))
                            .frame(width: 77, height: 70)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 7)
                    })
                    .background(Color.blue)
                    .cornerRadius(38.5)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
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
