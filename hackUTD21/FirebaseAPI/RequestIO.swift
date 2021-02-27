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
        self.dbref.child("Route").child(route.id).setValue(route)
    }
}
