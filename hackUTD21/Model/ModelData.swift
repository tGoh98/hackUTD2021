//
//  ModelData.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation
import Firebase
import SwiftUI

final class ModelData: ObservableObject {
    /*
     0 is feed
     1 is createRun
     */
    @Published var pageNum: Int = 0
//    @Published var showFAB: Bool = false
    @Published var requestIo = RequestIO(dbref: Database.database().reference())
    
    var feed: [CardInfo] = loadFeed()
}

func loadFeed() -> [CardInfo] {
    var ret = [CardInfo]()
    
    // TODO: this is dummy data that needs to be grabbed from firebase db
    ret.append(CardInfo(name: "tim", desc: "msg1"))
    ret.append(CardInfo(name: "tim", desc: "msg2"))
    ret.append(CardInfo(name: "tim", desc: "msg3"))
    ret.append(CardInfo(name: "tim", desc: "msg4"))
    ret.append(CardInfo(name: "tim", desc: "msg5"))
    ret.append(CardInfo(name: "tim", desc: "msg6"))
    ret.append(CardInfo(name: "tim", desc: "msg7"))
    ret.append(CardInfo(name: "tim", desc: "msg8"))
    ret.append(CardInfo(name: "tim", desc: "msg9"))
    ret.append(CardInfo(name: "tim", desc: "msg10"))
    
    return ret
}
