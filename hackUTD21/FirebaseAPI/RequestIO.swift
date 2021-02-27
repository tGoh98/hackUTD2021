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
        self.dbref.child("Route").child(route.id.uuidString).setValue(route)
    }
    
    /* Group */
    func createUser(name: String) {
        var user = User(name: name)
        self.dbref.child("User").setValue(["id": user.id.uuidString, "object": user])
    }
    
    
    /* User */
}
