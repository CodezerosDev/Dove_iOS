//
//  DNManagePlansVC.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNManagePlansVC: UIViewController {
    
    @IBOutlet weak var tblPlans: UITableView!
    var boolBuyingPlans:Bool = true
    @IBOutlet var btnsPlans: [DNCornerRadiusButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for btn in btnsPlans {
            
            btn.tag = btnsPlans.index(of: btn)!
            btn.isSelected = false
            btn.addTarget(self, action: #selector(btnPlansTapped(sender:)), for: .touchUpInside)
        }
        
        if boolBuyingPlans {
            btnsPlans[0].isSelected = true
        }else{
            btnsPlans[1].isSelected = true
        }
        
        tblPlans.dataSource = self
        tblPlans.delegate   = self
        
        DispatchQueue.main.async {
            self.tblPlans.animateTable()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFlipNavigationBar(title: "Manage Plans", largeTitle: true, tranpernt: false, buttonTint: .black)
    }
    
    @objc func btnPlansTapped(sender: UIButton){
        
        for btn in btnsPlans {
            btn.isSelected = false
        }
        sender.isSelected = true
        boolBuyingPlans = sender.tag == 0 ? true : false
        DispatchQueue.main.async {
            self.tblPlans.animateTable()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DNManagePlansVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if boolBuyingPlans {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DNConstant.PlansCellID.buyPlan) as! DNPlansTblCell
            cell.btnEditBuy.tag     = indexPath.row
            cell.btnDeleteBuy.tag   = indexPath.row
            
            cell.btnEditBuy.addTarget(self, action: #selector(btnEditBuyTapped(sender:)), for: .touchUpInside)
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DNConstant.PlansCellID.sellPlan) as! DNPlansTblCell
            cell.btnEditSell.tag    = indexPath.row
            cell.btnDeleteSell.tag  = indexPath.row
            
            cell.btnEditSell.addTarget(self, action: #selector(btnEditSellTapped(sender:)), for: .touchUpInside)
            
            return cell
            
        }
    }
    
    
    // buy buttons
    
    @objc func btnEditBuyTapped(sender: UIButton){
        
        let planDetails = DNConstant.StoryBoards.dashboard.instantiateViewController(withIdentifier: String(describing: DNPlanDetailsVC.self)) as! DNPlanDetailsVC
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(planDetails, animated: true)
        }
    }
    
    
    // sell buttons
    
    @objc func btnEditSellTapped(sender: UIButton){
        
        let planDetails = DNConstant.StoryBoards.dashboard.instantiateViewController(withIdentifier: String(describing: DNPlanDetailsVC.self)) as! DNPlanDetailsVC
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(planDetails, animated: true)
        }
    }
    
}



