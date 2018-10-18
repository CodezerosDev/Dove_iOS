//
//  AttractionAnnotationView.swift
//  Park View
//
//  Created by Niv Yahel on 2014-10-30.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

import UIKit
import MapKit

class DNAnnotationView: MKAnnotationView {
  
    let selectedLabel:UILabel = UILabel.init(frame:CGRect(x:0, y:0, width:140, height:38))
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point)
                if isInside
                {
                    break
                }
            }
        }
        return isInside
    }
  // Required for MKAnnotationView
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  // Called when drawing the AttractionAnnotationView
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
  
     init(annotation: MKAnnotation?, reuseIdentifier: String?,_attractiontype:PinType) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let attractionAnnotation = self.annotation as! DNAnnotation
        
        switch (attractionAnnotation.type) {
            
            case .UserLocation: image = #imageLiteral(resourceName: "yellowPin")
            break
            
            case .Auto: image = #imageLiteral(resourceName: "AutoPin")
            break
          
            case .Civil: image = #imageLiteral(resourceName: "EngineerPin")
            break

            case .Electrical: image = #imageLiteral(resourceName: "ElectricalPin")
            break
            
            case .Electrician: image = #imageLiteral(resourceName: "ElectricianPin")
            break
            
            case .Plumber: image = #imageLiteral(resourceName: "PlumberPin")
            break
            
            case .Febricator: image = #imageLiteral(resourceName: "FabricatorPin")
            break
            
            case .Weldor: image = #imageLiteral(resourceName: "WelderPin")
            break
            
            case .Carpenter: image = #imageLiteral(resourceName: "CarpenterPin")
            break
            
        }
        
    }
    

    }
