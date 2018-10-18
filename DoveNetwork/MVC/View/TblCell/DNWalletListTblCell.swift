//
//  DNWalletListTblCell.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNWalletListTblCell: UITableViewCell
{
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnExport: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblDove: UILabel!
    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var lblEather: UILabel!
    
    var dictWallet: NSDictionary!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadWalletListCell()
    {
        lblDove.text = "\(dictWallet.value(forKey: Wallet_balance)!)"
        lblEather.text = "\(dictWallet.value(forKey: Wallet_balance)!) Ether"
        lblWalletName.text = "\(dictWallet.value(forKey: Wallet_name)!)"
        
        if "\(dictWallet.value(forKey: Wallet_default)!)" == "1"
        {
            btnActive.setTitle("Active", for: .normal)
        }
        else
        {
            btnActive.setTitle("Set Active", for: .normal)
        }
    }
}
