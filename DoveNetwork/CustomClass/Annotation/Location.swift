//
//  Location.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/22/15.
//  Copyright (c) 2015 mnbayan. All rights reserved.
//

import Foundation
import CoreLocation

class Location{
  
    class func geocodeAddressString(address:String, completion:@escaping (_ placemark:CLPlacemark?, _ error:NSError?)->Void){
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
      if error == nil{
        if (placemarks?.count)! > 0{
            completion((placemarks?[0]), error as NSError?)
        }
      }
      else{
        completion(nil, (error! as NSError))
      }
    })
  }
  
    class func reverseGeocodeLocation(location:CLLocation,completion:@escaping (_ placemark:CLPlacemark?, _ error:NSError?)->Void){
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
      if let err = error{
        print("Error Reverse Geocoding Location: \(err.localizedDescription)")
        completion(nil, error! as NSError)
        return
      }
        completion(placemarks?[0], nil)
      
    })
  }
  
  class func addressFromPlacemark(placemark:CLPlacemark)->String{
    var address = ""
    
    if let name = placemark.addressDictionary?["Name"] as? String {
        address = constructAddressString(string: address, newString: name)
    }
  
    if let city = placemark.addressDictionary?["City"] as? String {
        address = constructAddressString(string: address, newString: city)
    }
    
    if let state = placemark.addressDictionary?["State"] as? String {
        address = constructAddressString(string: address, newString: state)
    }
    
    if let country = placemark.country{
        address = constructAddressString(string: address, newString: country)
    }
    
    return address
  }
  
  private class func constructAddressString(string:String, newString:String)->String{
    var address = string
    if !address.isEmpty{
        address = address.appendingFormat(", \(newString)")
    }
    else{
        address = address.appendingFormat(newString)
    }
    return address
  }
}
