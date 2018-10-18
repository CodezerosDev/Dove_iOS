//
//  DNRoundView.swift
//  DoveNetwork
//
//  Created by Reus on 11/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNRoundView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius     = 10.0
        layer.masksToBounds    = true
    }
    
    
    
    

}
