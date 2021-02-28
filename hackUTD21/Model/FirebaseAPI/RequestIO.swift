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
    var routes: Array<Route>
    var trailMomentUUIDs: Array<UUID>
    var trailVisibility: Visibility
//    var momentsForRoute: Array<Moment>
    
    init(dbref: DatabaseReference) {
        self.dbref = dbref
        self.users = [User]()
        self.moments = [Moment]()
        self.routes = [Route]()
        self.trailMomentUUIDs = [UUID]()
        self.trailVisibility = Visibility(type: 2)
//        self.momentsForRoute = [Moment]()
        
        getMoments()
        getRoutes()
        getUsers()
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
    
    /* get all users */
    func getUsers() {
        self.dbref.child("User").observe(.value, with: { (snapshot) in
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
    
    /* create a new moment */
    func createMoment(contents: Item, tags: Array<String>, coordinate: CLLocationCoordinate2D) -> UUID {
        var moment = Moment(contents: contents, tags: tags, latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.dbref.child("Moment").child(moment.id.uuidString).setValue(moment.toDictionary)
        return moment.id
    }
    
    /* get all moments */
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
//                let timeAdded = v?["timeAdded"] as? Date ?? Date()
                let tags = v?["tags"] as? Array<String> ?? [String]()
                
                let moment = Moment(id: id, contents: contents, tags: tags, latitude: latitude, longitude: longitude)
                self.moments.append(moment)
            }
        })
    }

    /* get all moments within a route with routeId uuid. */
    func getMomentsForRoute(routeId: UUID) -> Array<Moment> {
        getMoments()
        print("routeId: \(routeId)")
        let route = getRouteById(routeId: routeId)[0]
        let momentIdSet = Set<UUID>(route.moments.map { $0 })
        return moments.filter { momentIdSet.contains($0.id) }

    }
    
    /* Route */
    
    /* create a new route */
    func createRoute(currentUserUUID: UUID, distanceTraveled: Double, timeElapsed: Double, name: String, description: String) -> UUID {
        var route = Route(visibility: trailVisibility, moments: trailMomentUUIDs, creator: currentUserUUID, distanceTraveled: distanceTraveled, timeElapsed: timeElapsed, name: name, description: description)
        self.dbref.child("Route").child(route.id.uuidString).setValue(route.toDictionary)
        return route.id
    }
    
    /* get all routes */
    func getRoutes() {
        self.dbref.child("Route").observe(DataEventType.value, with: { (snapshot) in
            let enumerator = snapshot.children
            self.routes = [Route]()
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let v = rest.value as? NSDictionary
                let id = v?["id"] as? UUID ?? UUID()
                let visibility = v?["visibility"] as? Visibility ?? Visibility(type: 0)
                let moments = v?["moments"] as? Array<UUID> ?? [UUID]()
                let creator = v?["creator"] as? UUID ?? UUID()
                let distanceTraveled = v?["distanceTraveled"] as? Double ?? 0.0
                let timeElapsed = v?["timeElapsed"] as? Double ?? 0.0
                let name = v?["name"] as? String ?? ""
                let description = v?["description"] as? String ?? ""
                
                let route = Route(id: id, visibility: visibility, moments: moments, creator: creator, distanceTraveled: distanceTraveled, timeElapsed: timeElapsed, name: name, description: description)
                self.routes.append(route)
            }
        })
    }
    
    /* get a route with route id uuid */
    func getRouteById(routeId: UUID) -> Array<Route> {
        return self.routes.filter { $0.id == routeId }
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
