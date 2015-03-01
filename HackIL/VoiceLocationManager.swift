//
//  VoiceLocationManager.swift
//  Voice
//
//  Created by yiqin on 11/28/14.
//  Copyright (c) 2014 yiqin. All rights reserved.
//

import UIKit

/**
 Gelocation Manager
*/
class VoiceLocationManager: NSObject {
    
    var cityName = "any"
    var stateName = "any"
    
    
    class var sharedInstance : VoiceLocationManager {
        struct Static {
            static let instance = VoiceLocationManager()
        }
        return Static.instance
    }
    
    func getCurrentLocation() {
        
        let locMgr = INTULocationManager.sharedInstance()
        locMgr.requestLocationWithDesiredAccuracy(INTULocationAccuracy.City, timeout: 20.0, delayUntilAuthorized: true) { (currentLocation: CLLocation!, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
            println("Get currentLocation")
            
            if (status == INTULocationStatus.Success){
                // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                // currentLocation contains the device's current location.
                
                
                println(currentLocation.description)
                self.getCurrentCityFromINTULocationManager(currentLocation)
            }
            else if (status == INTULocationStatus.TimedOut) {
                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                // However, currentLocation contains the best location available (if any) as of right now,
                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
            }
            else {
                // An error occurred, more info is available by looking at the specific status returned.
            }
        }
    }
    
    func getCurrentCityFromINTULocationManager(locationManager: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationManager, completionHandler: { (placemarks: [AnyObject]!, error:NSError!) -> Void in
            
            if ((error) == nil){
                let placemark = (placemarks as NSArray).objectAtIndex(0) as CLPlacemark
                
                self.cityName = placemark.locality as String
                self.stateName = placemark.administrativeArea as String
                
                println("We get your location! ")
            }
        })
    }
    
}
