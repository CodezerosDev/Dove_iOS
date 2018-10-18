//
//  DNRecentPlanView.swift
//  DoveNetwork
//
//  Created by Reus on 12/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNRecentPlanView: UIView
{
    @IBOutlet weak var tblRecentPlan: UITableView!
    
    var boolShowAll:Bool = false
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        tblRecentPlan.register(UINib(nibName: String(describing: DNRecentPlanTblCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DNRecentPlanTblCell.self))
        
        tblRecentPlan.dataSource = self
        tblRecentPlan.delegate   = self
    }
    
    func reloadData(showAll:Bool, completion:@escaping ((_ constraint:CGFloat)->Void))
    {
        DispatchQueue.main.async{
            self.boolShowAll = showAll
            self.tblRecentPlan.reloadData()
            self.tblRecentPlan.layoutIfNeeded()
            completion(self.tblRecentPlan.contentSize.height)
        }
    }
}

extension DNRecentPlanView: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boolShowAll ? 10 : 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblRecentPlan.dequeueReusableCell(withIdentifier: String(describing: DNRecentPlanTblCell.self)) as! DNRecentPlanTblCell
        
        return cell
    }
    
}

