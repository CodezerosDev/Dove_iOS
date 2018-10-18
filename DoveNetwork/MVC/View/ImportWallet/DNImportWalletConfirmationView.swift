//
//  DNImportWalletConfirmationView.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNImportWalletConfirmationView: UIView
{
    @IBOutlet weak var btnBG: UIButton!
    @IBOutlet weak var lblConfirmation: UILabel!
    @IBOutlet weak var txtFAddress: UITextField!
    
    @IBOutlet weak var btnImportThisWallet: DNCornerRadiusButton!
    @IBOutlet weak var btnImportAgain: DNCornerRadiusButton!
    
    var actionCompletionHandler: ((_ index: Int)->Void)?
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
    }
   
    @IBAction func btnImportThisWalletPressed(_ sender: Any)
    {
        actionCompletionHandler?(0)
    }

    @IBAction func btnImportAgainPressed(_ sender: Any)
    {
        actionCompletionHandler?(1)
    }
}
