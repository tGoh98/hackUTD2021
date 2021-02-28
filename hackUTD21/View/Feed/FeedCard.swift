//
//  FeedCard.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import SwiftUI
import MapKit

struct FeedCard: View {
    var name: String
    var timeAdded: String
    var desc: String
    @State var moments: Array<Moment>
    @State var region: MKCoordinateRegion
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                Spacer()
                Text(timeAdded)
                    .foregroundColor(Color.init(hex: "757575"))
            }
            .padding(.vertical)
            
            Text(desc)
                .padding(.vertical)
                .onAppear(perform: {
                    print("feed moments", moments)
                })
            
            Map(coordinateRegion: $region, annotationItems: moments) { moment in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: moment.latitude, longitude: moment.longitude))
            }
                .frame(minHeight:200, maxHeight: 300)
                .padding(.vertical)
        }
        
    }
    
    func convertDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return df.string(from: date).replacingOccurrences(of: " ", with: " at ")
    }
}

struct FeedCard_Previews: PreviewProvider {
    static var previews: some View {
        FeedCard(name: "name", timeAdded: "ASDFASDF", desc: "descdescdesc", moments: [Moment(contents: Item(strMsg: "asdf"), tags: ["ASDF","ASDF"], latitude: 0.0, longitude: 0.0)], region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.7617, longitude: 80.1918), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    }
}


