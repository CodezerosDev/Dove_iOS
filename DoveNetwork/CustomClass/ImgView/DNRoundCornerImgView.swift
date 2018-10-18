//
//  DNRoundCornerImgView.swift
//  DoveNetwork
//
//  Created by Reus on 12/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNRoundCornerImgView: UIImageView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        personalizeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        personalizeView()
    }
    
    func personalizeView(){
        layer.cornerRadius     = 10.0
        layer.masksToBounds    = true
    }

}
