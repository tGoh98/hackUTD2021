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
                let id = v?["id"] as? String ?? ""
                let name = v?["name"] as? String ?? ""
                let groups = v?["groups"] as? Array<String> ?? [String]()
                let routes = v?["routes"] as? Array<String> ?? [String]()
                
                let user = User(id: UUID(uuidString: id) ?? UUID(), name: name, groups: groups.map { UUID(uuidString: $0) ?? UUID() }, routes: routes.map { UUID(uuidString: $0) ?? UUID() })
                self.users.append(user)
            }
        })
    }
    

    /* Moment */
    
    /* create a new moment */
    func createMoment(contents: Item, tags: Array<String>, coordinate: CLLocationCoordinate2D) -> Moment {
        var moment = Moment(contents: contents, tags: tags, latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.dbref.child("Moment").child(moment.id.uuidString).setValue(moment.toDictionary)
        return moment
    }
    
    /* get all moments */
    func getMoments() {
        self.dbref.child("Moment").observe(DataEventType.value, with: { (snapshot) in
            let enumerator = snapshot.children
            self.moments = [Moment]()
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let v = rest.value as? NSDictionary
                let id = v?["id"] as? String ?? ""
                let contents = v?["contents"] as? Item ?? Item(strMsg: "new item")
                let latitude = v?["latitude"] as? Double ?? 0.0
                let longitude = v?["longitude"] as? Double ?? 0.0
//                let timeAdded = v?["timeAdded"] as? Date ?? Date()
                let tags = v?["tags"] as? Array<String> ?? [String]()
                print("Moments id : ", id)
                let moment = Moment(id: UUID(uuidString: id) ?? UUID(), contents: contents, tags: tags, latitude: latitude, longitude: longitude)
                self.moments.append(moment)
            }
            print("local moments is \(self.moments)")
        })
    }

    /* get all moments within a route with routeId uuid. */
    func getMomentsForRoute(routeId: UUID) -> Array<Moment> {
        let route = getRouteById(routeId: routeId)[0]
        print("route is ", route, route.moments)
        let momentIdSet = Set<UUID>(route.moments.map { $0 })
        print("momentIdSet is ", momentIdSet)
        return moments.filter { momentIdSet.contains($0.id) }

    }
    
    
    func convertDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return df.string(from: date).replacingOccurrences(of: " ", with: " at ")
    }
    
    /* Route */
    
    /* create a new route */
    func createRoute(currentUserUUID: UUID, distanceTraveled: Double, timeElapsed: Double, name: String, description: String, timeCreated: Date = Date()) -> UUID {
        var route = Route(visibility: trailVisibility, moments: trailMomentUUIDs, creator: currentUserUUID, distanceTraveled: distanceTraveled, timeElapsed: timeElapsed, name: name, description: description, timeCreated: convertDate(date: timeCreated))
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
                let id = v?["id"] as? String ?? ""
                let visibility = v?["visibility"] as? Visibility ?? Visibility(type: 0)
                let moments = v?["moments"] as? Array<String> ?? [String]()
                let creator = v?["creator"] as? String ?? ""
                let distanceTraveled = v?["distanceTraveled"] as? Double ?? 0.0
                let timeElapsed = v?["timeElapsed"] as? Double ?? 0.0
                let name = v?["name"] as? String ?? ""
                let description = v?["description"] as? String ?? ""
                let timeCreated = v?["timeCreated"] as? String ?? ""
                print("Time Creates is" , timeCreated)
//                print(visibility, visibility.type)
                let route = Route(id: UUID(uuidString: id) ?? UUID() , visibility: visibility, moments: moments.map { UUID(uuidString: $0) ?? UUID()}, creator: UUID(uuidString: creator) ?? UUID(), distanceTraveled: distanceTraveled, timeElapsed: timeElapsed, name: name, description: description, timeCreated: timeCreated)
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


