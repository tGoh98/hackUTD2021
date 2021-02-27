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
    var users: Array<User>
    
    init(dbref: DatabaseReference) {
        self.dbref = dbref
        self.users = [User]()
    }
    
    /* Route */
    func createRoute(route: Route) {
        self.dbref.child("Route").child(route.id.uuidString).setValue(route)
    }
    
    
    /* User */
    
    
    func createUser(name: String) {
        var user = User(name: name)
        self.dbref.child("User").child(user.id.uuidString).setValue(user.toDictionnary)
    }
    
    func getUsers() {
        self.dbref.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let v = rest.value as? NSDictionary
                let id = v?["id"] as? UUID ?? UUID()
                let name = v?["name"] as? String ?? ""
                let groups = v?["groups"] as? Array<UUID> ?? [UUID]()
                let routes = v?["routes"] as? Array<UUID> ?? [UUID]()
                
                let user = User(id: id, name: name, groups: groups, routes: routes)
                self.users.append(user)
            }
        })
    }
    
    
    
    
    /* Group */
    
}


extension Encodable {
    var toDictionnary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
