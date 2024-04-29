//
//  AppDelegate+Location.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 29/04/24.
//

import Foundation
import CoreLocation

extension AppDelegate: CLLocationManagerDelegate {
    
    func setUpLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()

        locationManager?.startUpdatingLocation()

    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        locationManager?.stopUpdatingLocation()
//        if (error) {
          print("Error \(error.localizedDescription)")
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        print(coord.latitude)
        print(coord.longitude)
        self.currentLocation = locationObj
        self.locationUpdateDelegate?.locationUpdated()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            print(#function)
            var shouldIAllow = false
            var locationStatus = ""
            switch status {
            case CLAuthorizationStatus.restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.notDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                locationManager?.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
                locationManager?.stopUpdatingLocation()
            }
    }
}


