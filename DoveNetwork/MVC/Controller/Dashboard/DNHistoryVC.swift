//
//  DNHistoryVC.swift
//  DoveNetwork
//
//  Created by Reus on 12/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNHistoryVC: UIViewController {
    
    @IBOutlet var btnsHistory: [DNCornerRadiusButton]!
    @IBOutlet weak var tblHistory: UITableView!
    
    var boolBuyingHistory:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for btn in btnsHistory {
            
            btn.tag = btnsHistory.index(of: btn)!
            btn.isSelected = false
            btn.addTarget(self, action: #selector(btnHistoryTapped(sender:)), for: .touchUpInside)
        }
        
        if boolBuyingHistory {
            btnsHistory[0].isSelected = true
        }else{
            btnsHistory[1].isSelected = true
        }
        
        tblHistory.dataSource  = self
        tblHistory.delegate    = self
        
        DispatchQueue.main.async {
            self.tblHistory.animateTable()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setFlipNavigationBar(title: "History", largeTitle: true, tranpernt: false, buttonTint: .black)
    }
    
    @objc func btnHistoryTapped(sender: UIButton){
        
        for btn in btnsHistory {
            btn.isSelected = false
        }
        sender.isSelected = true
        boolBuyingHistory = sender.tag == 0 ? true : false
        DispatchQueue.main.async {
            self.tblHistory.animateTable()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension DNHistoryVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if boolBuyingHistory{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DNConstant.HistoryCellID.buying)) as! DNHistoryCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DNConstant.HistoryCellID.selling)) as! DNHistoryCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHistoryDetails()
    }
    
    
}

