//
//  DNPlansTblCell.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNPlansTblCell: UITableViewCell
{
    @IBOutlet weak var btnEditBuy: UIButton!
    @IBOutlet weak var btnDeleteBuy: UIButton!
    
    @IBOutlet weak var btnEditSell: UIButton!
    @IBOutlet weak var btnDeleteSell: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
