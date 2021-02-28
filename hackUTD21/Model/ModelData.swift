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
}
