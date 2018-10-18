//
//  AttractionAnnotation.swift
//  Park View
//
//  Created by Niv Yahel on 2014-10-30.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

import UIKit
import MapKit

enum PinType: Int {
    
  case UserLocation
  case Auto
  case Civil
  case Electrical
  case Electrician
  case Plumber
  case Carpenter
  case Febricator
  case Weldor

}

class DNAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    
    var title: String!
    var subtitle: String!
    
    var type: PinType
    
    init(coordinate: CLLocationCoordinate2D, title: String,
         subtitle: String, type: PinType) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
    self.type = type
  }
}
