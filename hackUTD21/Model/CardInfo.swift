//
//  CardInfo.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation
import MapKit

class CardInfo: Identifiable {
    var id: UUID
    var timeAdded: String
    var name: String
    var desc: String
    var moments: Array<Moment>
    var firstCoord: CLLocationCoordinate2D
   
    
    init(id: UUID = UUID(), timeAdded: String, name: String = "name", desc: String = "desc", moments: Array<Moment> = [Moment]()) {
        self.id = id
        self.timeAdded = timeAdded
        self.name = name
        self.desc = desc
        self.moments = moments
        if (moments.count > 0) {
            self.firstCoord = CLLocationCoordinate2D(latitude: moments[0].latitude, longitude: moments[0].longitude)
        }
        else {
            self.firstCoord = CLLocationCoordinate2D(latitude: 29.7174, longitude: -95.4018)
        }
    }
}
