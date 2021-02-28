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
    @Published var pageNum: Int = 0
    //    @Published var showFAB: Bool = false
    @Published var requestIo = RequestIO(dbref: Database.database().reference())
    @Published var currentUserUUID = UUID(uuidString: "eda6f5ac-6fd3-4d2e-9919-950dbe5947cb")
    @Published var feed: [CardInfo] = [CardInfo]()
    
    @Published var createdRouteId: UUID = UUID()
    @Published var uploadURLs: Array<URL> = [URL]()
    @Published var createMomentCount: Int = 0

}



func loadFeed(modelData: ModelData) {
    let requestIo = modelData.requestIo
    var ret = [CardInfo]()
    
//    requestIo.getRoutes()
//    requestIo.getMoments()
    
    
    requestIo.routes.forEach {
        print("route id", $0.id)
        ret.append(CardInfo(name: $0.name, desc: $0.description, moments: requestIo.getMomentsForRoute(routeId: $0.id)))
    }
//    print(ret, ret[0].name, ret[0].moments)
//
    // TODO: this is dummy data that needs to be grabbed from firebase db
//    ret.append(CardInfo(name: "tim", desc: "msg1"))
//    ret.append(CardInfo(name: "tim", desc: "msg2"))
//    ret.append(CardInfo(name: "tim", desc: "msg3"))
//    ret.append(CardInfo(name: "tim", desc: "msg4"))
//    ret.append(CardInfo(name: "tim", desc: "msg5"))
//    ret.append(CardInfo(name: "tim", desc: "msg6"))
//    ret.append(CardInfo(name: "tim", desc: "msg7"))
//    ret.append(CardInfo(name: "tim", desc: "msg8"))
//    ret.append(CardInfo(name: "tim", desc: "msg9"))
//    ret.append(CardInfo(name: "tim", desc: "msg10"))
    
    modelData.feed = ret
//        return ret
}
