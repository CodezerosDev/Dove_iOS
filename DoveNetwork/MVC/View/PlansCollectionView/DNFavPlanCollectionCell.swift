//
//  DNFavPlanCollectionCell.swift
//  DoveNetwork
//
//  Created by Reus on 12/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNFavPlanCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var btnFav: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var setImage:UIImage = #imageLiteral(resourceName: "btnFavPlanBuy"){
        didSet{
            btnFav.setBackgroundImage(setImage, for: .normal)
        }
    }

}
