//
//  UICollectionView+Layout.swift
//  DoveNetwork
//
//  Created by Reus on 12/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewLayout
{
    func setPlansLayout(frame:CGRect)->UICollectionViewFlowLayout
    {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: ((frame.width - 16) / 1.8) , height: frame.height)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = 0.0
        _flowLayout.minimumLineSpacing = 4.0
        
        return _flowLayout
    }
    
    func setProceduresLayout(frame:CGRect)->UICollectionViewFlowLayout
    {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: frame.width , height: frame.height)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = 0.0
        _flowLayout.minimumLineSpacing = 0.0
        
        return _flowLayout
    }
}

