//
//  Moment.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation
import MapKit

class Moment: Identifiable, Codable {
    var id: UUID
    var contents: Item
    var latitude: Double
    var longitude: Double
    var timeAdded: Date
    var tags: Array<String>
   
    
    init(id: UUID = UUID(), contents: Item, tags: Array<String>, latitude: Double, longitude: Double) {
        self.id = id
        self.contents = contents
        self.latitude = latitude
        self.longitude = longitude
        self.timeAdded = Date() // gets the current time
        self.tags = tags
    }
}
