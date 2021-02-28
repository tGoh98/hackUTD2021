//
//  TrailDetail.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import SwiftUI
import MapKit

struct TrailDetail: View {
    @EnvironmentObject var modelData: ModelData
    var card: FeedCard
    @State private var action: Int? = 0
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
//    var btnBack : some View { Button(action: {
//        self.mode.wrappedValue.dismiss()
//        modelData.showFAB = true
//        print("showFAB is now true")
//    }) {
//        HStack {
//            Image(systemName: "chevron.left") // set image here
//                .aspectRatio(contentMode: .fit)
//            Text("Home")
//        }
//    }
//    }
    
    var body: some View {
        VStack {
            card
                .padding()
            
            NavigationLink(destination: Text("Try Trail"), tag: 1, selection: $action) {
                EmptyView()
            }.navigationTitle("Trail")
            
            Spacer()
            
            Button (action: {self.action = 1})
            {
                Text("Try trail")
                    .fontWeight(.semibold)
                    .font(.title3)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.init(hex: "FE5722"))
            .cornerRadius(40)
            .padding(.horizontal, 80)
            
            Spacer()
            
        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: btnBack)
    }
    
}

struct TrailDetail_Previews: PreviewProvider {
    static var previews: some View {
        TrailDetail(card: FeedCard(name:"tim", timeAdded: "ASDFASDFA", desc: "snoooooopy", moments: [Moment(contents: Item(strMsg: "asdf"), tags: ["ASDF","ASDF"], latitude: 0.0, longitude: 0.0)], region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.7617, longitude: 80.1918), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))))
            .environmentObject(ModelData())
    }
}
