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
    @Published var requestIo = RequestIO(dbref: Database.database().reference())
    @Published var currentUserUUID = UUID(uuidString: "eda6f5ac-6fd3-4d2e-9919-950dbe5947cb")
}
