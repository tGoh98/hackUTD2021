//
//  Item.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation

class Item: Identifiable {
    var id: UUID
    var strMsg: String
    var imgSrc: String
    var vidSrc: String
   
    init(id: UUID = UUID(), strMsg: String) {
        self.id = id
        self.strMsg = strMsg
        self.imgSrc = "imgSrc"
        self.vidSrc = "vidSrc"
    }
}
