//
//  DNWalletDeleteView.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNWalletDeleteView: UIView
{
    var actionCompletionHandler: ((_ index: Int)->Void)?
    
    override func draw(_ rect: CGRect)
    {
       super.draw(rect)
    }
    
    @IBAction func btnDeleteWallet(_ sender: DNCornerRadiusButton)
    {
        actionCompletionHandler?(0)
    }
    
    @IBAction func btnCancelTapped(_ sender: DNCornerRadiusButton)
    {
        actionCompletionHandler?(1)
    }
}
