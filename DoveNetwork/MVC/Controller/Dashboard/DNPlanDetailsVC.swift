//
//  DNPlanDetailsVC.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNPlanDetailsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCommonNavigationBar(title: "Economy - 350", largeTitle: true, tranpernt: false, buttonTint: .black)
    }
    
    
    @IBAction func btnSaveTapped(_ sender: DNCornerRadiusButton) {
        DispatchQueue.main.async {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnDeletePlan(_ sender: DNCornerRadiusButton) {
        showDeletePopup()
    }
    
    @IBAction func btnCancelTapped(_ sender: DNCornerRadiusButton) {
        DispatchQueue.main.async {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
