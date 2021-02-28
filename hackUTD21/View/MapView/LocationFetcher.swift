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
    var regions = [CLRegion]()
    @Published var alerted: Bool = false

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: 29.71075045624731, longitude: -95.41610668658146), identifier: "Neighbor1")
        alerted.toggle()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
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
            regions.append(region)
            notifyEntry()
        }
    }
    
    func notifyEntry() {
        print(regions)
    }
}
