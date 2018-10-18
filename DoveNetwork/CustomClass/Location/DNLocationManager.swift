//
//  PALocationManager.swift
//  PessangerApp
//
//  Created by Rameshwar on 12/27/17.
//  Copyright © 2017 Rameshwar. All rights reserved.
//

import UIKit
import CoreLocation

protocol HMLocationManagerDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: Error)
}

class DNLocationManager: NSObject,CLLocationManagerDelegate {

    class var sharedInstance: DNLocationManager {
        struct Static {
            
            lazy var onceToken = 0
            static var instance: DNLocationManager? = nil
        }
       // dispatch_once(&Static.onceToken) {
        Static.instance = DNLocationManager()
        //}
        return Static.instance!
    }
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: HMLocationManagerDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last location
        self.lastLocation = location
        
        // use for real time update location
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // do on error
        updateLocationDidFailWithError(error: error)
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: Error) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    
    func getCountryName() -> String {
        
        let geocoder = CLGeocoder()
        print("-> Finding user address...")
        var addressString : String = ""
        
        geocoder.reverseGeocodeLocation((self.locationManager?.location!)!, completionHandler: {(placemarks, error)->Void in
            var placemark:CLPlacemark!
            if error == nil && placemarks!.count > 0 {
                placemark = placemarks![0] as CLPlacemark
                if placemark.isoCountryCode == "TW" /*Address Format in Chinese*/ {
                    if placemark.country != nil {
                        addressString = placemark.country!
                    }
                } else {
                    
                    if placemark.country != nil {
                        addressString = addressString + placemark.country!
                    }
                }
                print(addressString)
            }
        })
        
        return addressString
        
    }
    
    
}
