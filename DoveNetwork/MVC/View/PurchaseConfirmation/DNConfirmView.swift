//
//  DNConfirmView.swift
//  DoveNetwork
//
//  Created by Reus on 12/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNConfirmView: UIView
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnSuccess: DNCornerRadiusButton!
    
    var clouserBtnTapped:((_ index: Int)->Void)?
    
    var setMessage : String = ""
    {
        didSet {
           lblMessage.text = setMessage
        }
    }

    var setTitle : String = ""
    {
        didSet {
            lblTitle.text = setTitle
        }
    }
    
    var setbuttonTitle : String = ""
    {
        didSet {
            btnSuccess.setTitle(setbuttonTitle, for: .normal)
        }
    }
    
    var btnColor : UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    {
        didSet {
            btnSuccess.backgroundColor = btnColor
        }
    }
   
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
    }
    
    @IBAction func btnPayTapped(_ sender: UIButton)
    {
        clouserBtnTapped?(0)
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton)
    {
        clouserBtnTapped?(1)
    }
    
}
