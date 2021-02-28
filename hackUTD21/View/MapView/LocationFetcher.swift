//
//  LocationFetcher.swift
//  hackUTD21
//
//  Created by Seung Hun Jang on 2/27/21.
//

import Foundation
import CoreLocation
import FirebaseDatabase

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    var regions = [String: CLRegion]()
    
    @Published var geofenceTriggered: Bool = false
    @Published var trailDistance: Double = 0.0
    @Published var trailStraightDistance: Double = 0.0
    @Published var trailStartTime: DispatchTime = DispatchTime.now()
    @Published var trailEndTime: DispatchTime = DispatchTime.now()
    @Published var startLocation: CLLocation!
    @Published var lastLocation: CLLocation!
    @Published var imgSrc: String = ""
    @Published var identifier: String = ""
    
    var tempImgSrc: String = ""
    
    override init() {
        super.init()
        manager.delegate = self
        
    }
    
    func calculateTimeTaken() -> Double {
        print(trailEndTime.uptimeNanoseconds)
        print(trailStartTime.uptimeNanoseconds)
        let nanoTime: UInt64
        if (trailEndTime.uptimeNanoseconds > trailStartTime.uptimeNanoseconds) {
            nanoTime = trailEndTime.uptimeNanoseconds - trailStartTime.uptimeNanoseconds
        } else {
            nanoTime = trailStartTime.uptimeNanoseconds - trailEndTime.uptimeNanoseconds
        }

        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
        
        print("Time taken for this trail: \(timeInterval) seconds")
        return timeInterval // returns seconds
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        
        if startLocation == nil {
            self.startLocation = locations.first
        } else if let location = locations.last {
            self.trailDistance += Double(lastLocation.distance(from: location)) / 1609.0 // convert meters to feet
            self.trailStraightDistance += Double(startLocation.distance(from: locations.last!)) / 1609.0
            print("Traveled Distance:",  self.trailDistance)
            print("Straight Distance:", self.startLocation.distance(from: locations.last!))
        }
        self.lastLocation = locations.last
        print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
    }
    
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the devices supports region monitoring.
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let maxDistance = 10.0
            let region = CLCircularRegion(center: center,
                                          radius: maxDistance, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = false
            
            manager.startMonitoring(for: region)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            identifier = region.identifier // this is moment's uuid
            
            let dbref = Database.database().reference()
            dbref.child("/Moment/\(identifier)/contents").getData { (error, snapshot) in
                if let error = error {
                    print("Error getting data \(error)")
                }
                else if snapshot.exists() {
                    
                    print("Got data \(snapshot.value!)")
                    let v = snapshot.value as? NSDictionary
                    let imgSrc = v?["imgSrc"] as? String ?? ""
                    self.tempImgSrc = imgSrc
                }
                else {
                    print("No data available")
                }
            }

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: notifyEntry)
    }
    
    
    func notifyEntry() {
        geofenceTriggered = true
        self.imgSrc = self.tempImgSrc
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            regions[identifier] = nil
            notifyExit()
        }
    }
    
    func notifyExit() {
        geofenceTriggered = false
    }
}
