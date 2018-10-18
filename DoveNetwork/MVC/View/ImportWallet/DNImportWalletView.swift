//
//  DNImportWalletView.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNImportWalletView: UIView
{
    @IBOutlet weak var btnBG: UIButton!
    @IBOutlet weak var btnPasteAddress: DNCornerRadiusButton!
    @IBOutlet weak var btnScanBarcode: DNCornerRadiusButton!
    @IBOutlet weak var btnSelectFile: DNCornerRadiusButton!
    @IBOutlet weak var btnCancel: DNCornerRadiusButton!
    
    var clouserActionHandler: ((_ index: Int)->Void)?
    
    override func draw(_ rect: CGRect)
    {
       super.draw(rect)
    }
    
    @IBAction func btnPasteAddressPressed(_ sender: Any)
    {
        clouserActionHandler?(0)
    }
    
    @IBAction func btnScanBarcodePressed(_ sender: Any)
    {
        clouserActionHandler?(1)
    }
    
    @IBAction func btnSelectFilePressed(_ sender: Any)
    {
        clouserActionHandler?(2)
    }
    
    @IBAction func btnCancelPressed(_ sender: Any)
    {
        removeFromSuperview()
    }
}
