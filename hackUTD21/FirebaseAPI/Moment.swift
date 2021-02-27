//
//  Moment.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation

class Moment: Identifiable {
    var id: UUID
    var contents: Item
    var location: String // TODO: change this to geo type
    var timeAdded: Date
    var tags: Array<String>
   
    
    init(id: UUID = UUID(), contents: String, tags: Array<String>) {
        self.id = id
        self.contents = Item(strMsg: contents)
        self.location = "TODO: make a call and get it here"
        self.timeAdded = Date() // gets the current time
        self.tags = tags
    }
}
