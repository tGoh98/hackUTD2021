//
//  api.swift
//  hackUTD21
//
//  Created by Timothy Goh on 2/27/21.
//

import Foundation
import FirebaseDatabase
import MapKit


class RequestIO {
    
    var dbref: DatabaseReference
    var users: Array<User>
    var moments: Array<Moment>
    var trailMomentUUIDs: Array<UUID>
    var trailVisibility: Visibility
    
    init(dbref: DatabaseReference) {
        self.dbref = dbref
        self.users = [User]()
        self.moments = [Moment]()
        self.trailMomentUUIDs = [UUID]()
        self.trailVisibility = Visibility(type: 2)
        
        getMoments()
    }
    
    /* Route */
    func createRoute(route: Route) {
        self.dbref.child("Route").child(route.id.uuidString).setValue(route)
    }
    
    
    /* User */
    
    
    func createUser(name: String) {
        var user = User(name: name)
        self.dbref.child("User").child(user.id.uuidString).setValue(user.toDictionary)
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
    

    /* Moment */
    
    func createMoment(contents: Item, tags: Array<String>, coordinate: CLLocationCoordinate2D) -> UUID {
        var moment = Moment(contents: contents, tags: tags, latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.dbref.child("Moment").child(moment.id.uuidString).setValue(moment.toDictionary)
        return moment.id
    }
    
    func getMoments() {
        self.dbref.child("Moment").observe(DataEventType.value, with: { (snapshot) in
            let enumerator = snapshot.children
            self.moments = [Moment]()
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let v = rest.value as? NSDictionary
                let id = v?["id"] as? UUID ?? UUID()
                let contents = v?["contents"] as? Item ?? Item(strMsg: "new item")
                let latitude = v?["latitude"] as? Double ?? 0.0
                let longitude = v?["longitude"] as? Double ?? 0.0
                let timeAdded = v?["timeAdded"] as? Date ?? Date()
                let tags = v?["tags"] as? Array<String> ?? [String]()
                
                let moment = Moment(id: id, contents: contents, tags: tags, latitude: latitude, longitude: longitude)
                self.moments.append(moment)
            }
        })
    }
    
    /* Route */
    
    func createRoute(currentUserUUID: UUID, distanceTraveled: Double, timeElapsed: Double) -> UUID {
        var route = Route(visibility: trailVisibility, moments: trailMomentUUIDs, creator: currentUserUUID, distanceTraveled: distanceTraveled, timeElapsed: timeElapsed)
        self.dbref.child("Route").child(route.id.uuidString).setValue(route.toDictionary)
        return route.id
    }
    
    
    /* Group */
    
    
}


extension Encodable {
    var toDictionary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
