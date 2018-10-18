//
//  DNExportWalletView.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNExportWalletView: UIView
{
    @IBOutlet weak var btnBG: UIButton!
    @IBOutlet weak var imgViewQR: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnCopyAddress: DNCornerRadiusButton!
    @IBOutlet weak var btnCancel: DNCornerRadiusButton!
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        lblAddress.adjustsFontSizeToFitWidth = true
    }
   
    @IBAction func btnCancelPressed(_ sender: Any)
    {
        removeFromSuperview()
    }
}
