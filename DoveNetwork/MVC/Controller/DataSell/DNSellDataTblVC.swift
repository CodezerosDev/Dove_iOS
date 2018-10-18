//
//  DNSellDataTblVC.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNSellDataTblVC: UITableViewController {
    
    @IBOutlet weak var viewFavPlans: UIView!
    @IBOutlet weak var viewRecentPlan: UIView!
    @IBOutlet weak var constraintRecentH: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblVoulme: UILabel!
    var recentPlanView = DNConstant.Xibs.recentPlanView
    
    @IBOutlet weak var btnVoulme: UIButton!
    @IBOutlet weak var chartSellData: LineChart!
    
    let chooseVolumeDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseVolumeDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChooseVolumeDropDown()
        
        let dataEntries = generateRandomEntries()
        
        chartSellData.dataEntries = dataEntries
        chartSellData.isCurved = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCommonNavigationBar(title: "", largeTitle: false, tranpernt: false, buttonTint: .black)
        
        let planView = DNConstant.Xibs.favPlanView
        planView.frame = viewFavPlans.bounds
        planView.setBoolBuy = false
        viewFavPlans.addSubview(planView)
        
        recentPlanView.frame = viewRecentPlan.bounds
        viewRecentPlan.addSubview(recentPlanView)
        
        recentPlanView.reloadData(showAll: false) { (constraint) in
            DispatchQueue.main.async {
                self.constraintRecentH.constant = constraint + 40
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
        
    }
    
    @IBAction func btnManage(_ sender: UIButton) {
        
        let managePlan = DNConstant.StoryBoards.dashboard.instantiateViewController(withIdentifier: String(describing: DNManagePlansVC.self)) as! DNManagePlansVC
        
        managePlan.boolBuyingPlans = false
        
        DispatchQueue.main.async {
            
            UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.navigationController?.pushViewController(managePlan, animated: false)
            }, completion: nil)
        }
    }
    
    @IBAction func btnViewAll(_ sender: UIButton) {
        
        let history = DNConstant.StoryBoards.dashboard.instantiateViewController(withIdentifier: String(describing: DNHistoryVC.self)) as! DNHistoryVC
        
        history.boolBuyingHistory = false
        
        DispatchQueue.main.async {
            
            UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.navigationController?.pushViewController(history, animated: false)
            }, completion: nil)
        }
    }
    
    @IBAction func btnContinue(_ sender: UIButton) {
        
        let sellDataProceedure = DNConstant.StoryBoards.sellData.instantiateViewController(withIdentifier: String(describing: DNSellProceedureVC.self)) as! DNSellProceedureVC
        let navEditorViewController: UINavigationController = UINavigationController(rootViewController: sellDataProceedure)
        DispatchQueue.main.async {
            self.present(navEditorViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnVoulmeTapped(_ sender: UIButton) {
        chooseVolumeDropDown.show()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension DNSellDataTblVC{
    
    func setupChooseVolumeDropDown() {
        chooseVolumeDropDown.anchorView = btnVoulme
        
        // Will set a custom with instead of anchor view width
        //        dropDown.width = 100
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        chooseVolumeDropDown.bottomOffset = CGPoint(x: 0, y: btnVoulme.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseVolumeDropDown.dataSource = [
            "MB",
            "GB"
        ]
        
        // Action triggered on selection
        chooseVolumeDropDown.selectionAction = { [weak self] (index, item) in
            //self?.chooseArticleButton.setTitle(item, for: .normal)
            self?.lblVoulme.text = item
            
        }
        
        //        chooseVolumeDropDown.multiSelectionAction = { [weak self] (indices, items) in
        //            print("Muti selection action called with: \(items)")
        //            if items.isEmpty {
        //               // self?.chooseArticleButton.setTitle("", for: .normal)
        //            }
        //        }
        
    }
}



extension DNSellDataTblVC {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            
            return DNConstant.appDelegate.isSellPlanRunning ? 0 : UITableViewAutomaticDimension
            
        }else if indexPath.row == 2 || indexPath.row == 3{
            
            return DNConstant.appDelegate.isSellPlanRunning ? UITableViewAutomaticDimension : 0
        }else{
            return UITableViewAutomaticDimension
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            
            return DNConstant.appDelegate.isSellPlanRunning ? 0 : UITableViewAutomaticDimension
            
        }else if indexPath.row == 2 || indexPath.row == 3{
            
            return DNConstant.appDelegate.isSellPlanRunning ? UITableViewAutomaticDimension : 0
        }else{
            return UITableViewAutomaticDimension
            
        }
    }
}


extension DNSellDataTblVC{
    
    private func generateRandomEntries() -> [PointEntry] {
        var result: [PointEntry] = []
        
        for i in 0..<5 {
            let value = Int(arc4random() % 30)
            result.append(PointEntry(value: value, label:"\(i + 1)"))
        }
        
        return result
    }
}


