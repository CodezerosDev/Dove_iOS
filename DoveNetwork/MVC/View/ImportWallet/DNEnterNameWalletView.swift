//
//  DNEnterNameWalletView.swift
//  DoveNetwork
//
//  Created by Ayush Kanodia on 20/08/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNEnterNameWalletView: UIView
{
    @IBOutlet weak var btnBG: UIButton!
    @IBOutlet weak var lblConfirmation: UILabel!
    @IBOutlet weak var lblEather: UILabel!
    @IBOutlet weak var lblDove: UILabel!
    @IBOutlet weak var txtFEnterName: UITextField!
    
    @IBOutlet weak var btnSubmit: DNCornerRadiusButton!
    @IBOutlet weak var btnCancel: DNCornerRadiusButton!
    
    var actionCompletionHandler: ((_ index: Int)->Void)?
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
    }
    
    @IBAction func btnSubmitPressed(_ sender: Any)
    {
        actionCompletionHandler?(0)
    }
    
    @IBAction func btnCancelPressed(_ sender: Any)
    {
        actionCompletionHandler?(1)
    }
}
