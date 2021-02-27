//
//  api.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation
import FirebaseDatabase

class RequestIO {
    var dbref: DatabaseReference
    
    init(dbref: DatabaseReference) {
        self.dbref = dbref
    }
    
    /* Route */
    func createRoute(route: Route) {
        let idStr = route.id.uuidString
        self.dbref.child("routes").child(idStr).setValue(["id":idStr, "asdf":"val"])
    }
}
