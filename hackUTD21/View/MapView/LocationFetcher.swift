//
//  LocationFetcher.swift
//  hackUTD21
//
//  Created by Seung Hun Jang on 2/27/21.
//

import Foundation
import CoreLocation

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
    
    override init() {
        super.init()
        manager.delegate = self
        
    }
    
    func calculateTimeTaken() -> Double {
//        print(trailEndTime.uptimeNanoseconds)
//        print(trailStartTime.uptimeNanoseconds)
        let nanoTime = trailStartTime.uptimeNanoseconds - trailEndTime.uptimeNanoseconds// <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
        
        print("Time taken for this trail: \(timeInterval) seconds")
        return timeInterval
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // TODO: When do we call monitorRegionAtLocation? For which moments?
        monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: 29.71075045624731, longitude: -95.41610668658146), identifier: "Neighbor1")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            trailDistance += lastLocation.distance(from: location)
            trailStraightDistance += startLocation.distance(from: locations.last!)
            print("Traveled Distance:",  trailDistance)
            print("Straight Distance:", startLocation.distance(from: locations.last!))
        }
        lastLocation = locations.last
        print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
    }
    
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the devices supports region monitoring.
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let maxDistance = 50.0
            let region = CLCircularRegion(center: center,
                                          radius: maxDistance, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
            manager.startMonitoring(for: region)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            regions[identifier] = region
            notifyEntry()
        }
    }
    
    
    func notifyEntry() {
        geofenceTriggered = true
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
