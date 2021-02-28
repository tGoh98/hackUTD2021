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

    @Published var requestIo = RequestIO(dbref: Database.database().reference())
    @Published var currentUserUUID = UUID(uuidString: "eda6f5ac-6fd3-4d2e-9919-950dbe5947cb")
    @Published var feed: [CardInfo] = [CardInfo]()
    
    @Published var createdRouteId: UUID = UUID()
    @Published var uploadURLs: Array<URL> = [URL]()
    @Published var createMomentCount: Int = 0
    
    @Published var selectedRouteId: UUID = UUID()

}



func loadFeed(modelData: ModelData) {
    let requestIo = modelData.requestIo
    var ret = [CardInfo]()
    
    requestIo.routes.forEach {
        print("route id", $0.id)
        ret.append(CardInfo(timeAdded: $0.timeCreated, name: $0.name, desc: $0.description, moments: requestIo.getMomentsForRoute(routeId: $0.id), routeId: $0.id))
    }
    
    modelData.feed = ret
}
