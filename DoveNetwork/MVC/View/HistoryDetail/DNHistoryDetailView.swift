//
//  DNHistoryDetailView.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNHistoryDetailView: UIView
{
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
    }

    @IBAction func btnCloseTapped(_ sender: DNCornerRadiusButton)
    {
        removeFromSuperview()
    }
}
