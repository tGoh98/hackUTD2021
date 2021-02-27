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
   
    init(strMsg: String, imgSrc: String, vidSrc: String) {
        self.id = UUID()
        self.strMsg = strMsg
        self.imgSrc = imgSrc
        self.vidSrc = vidSrc
    }
}
