//
//  DNFavPlan.swift
//  DoveNetwork
//
//  Created by Reus on 12/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNFavPlan: UIView {
   
    @IBOutlet weak var collectionPlans: UICollectionView!
    
    var boolBuy:Bool = true
    
    
    var setBoolBuy: Bool = true{
        didSet{
            boolBuy = setBoolBuy
            collectionPlans.reloadData()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        collectionPlans.register(UINib(nibName:String(describing: DNFavPlanCollectionCell.self), bundle: nil), forCellWithReuseIdentifier:String(describing: DNFavPlanCollectionCell.self) )
        
        collectionPlans.collectionViewLayout = UICollectionViewLayout().setPlansLayout(frame: collectionPlans.bounds)
        
        collectionPlans.delegate = self
        collectionPlans.dataSource = self
    }

}


extension DNFavPlan: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DNFavPlanCollectionCell.self), for: indexPath) as! DNFavPlanCollectionCell
       
        cell.setImage = boolBuy ? #imageLiteral(resourceName: "btnFavPlanBuy") : #imageLiteral(resourceName: "btnFavPlanSell")
        
        return cell
    }
    
}
