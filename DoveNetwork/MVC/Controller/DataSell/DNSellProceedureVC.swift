//
//  DNSellProceedureVC.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNSellProceedureVC: UIViewController {
    
    @IBOutlet weak var viewSummary: UIView!
    @IBOutlet var btnProcedures: [DNCornerRadiusButton]!
    @IBOutlet weak var collectionProcedures: UICollectionView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    
    var selectedProcedure: Int = 1
    
    
    let chooseDurationDropDown  = DropDown()
    let chooseSpeedDropDown     = DropDown()
    let choosePriceDropDown     = DropDown()
    
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseDurationDropDown,
            self.chooseSpeedDropDown,
            self.choosePriceDropDown
        ]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionProcedures.collectionViewLayout = UICollectionViewLayout().setProceduresLayout(frame: collectionProcedures.bounds)
        
        collectionProcedures.dataSource = self
        collectionProcedures.delegate   = self
        
        // procedures states
        
        for btn in btnProcedures {
            
            btn.tag         = btnProcedures.index(of: btn)!
            btn.isSelected  = false
            btn.addTarget(self, action: #selector(btnProceduresTapped(sender:)), for: .touchUpInside)
            
        }
        
        btnProcedures[1].isSelected = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPresentedNavigationBar(title: "Sell Data", largeTitle: true, tranpernt: true, buttonTint: .black)
    }
    
    
    @objc func btnProceduresTapped(sender: UIButton){
        
        for btn in btnProcedures {
            
            btn.tag         = btnProcedures.index(of: btn)!
            btn.isSelected  = false
        }
        
        btnNext.setTitle("Next", for: .normal)
        
        print(sender.tag)
        
        if sender.tag > 0 && sender.tag < 4 {
            
            collectionProcedures.scrollToItem(at: IndexPath(item: sender.tag - 1, section: 0), at: .centeredHorizontally, animated: true)
            selectedProcedure = (sender.tag) + 1
            viewSummary.isHidden = true
            imgLogo.isHidden = false
        }else if sender.tag == 4 {
            
            selectedProcedure = (sender.tag) + 1
            viewSummary.isHidden = false
            btnNext.setTitle("Pay", for: .normal)
            imgLogo.isHidden = true
            
        }else{
            
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
        }
        
        sender.isSelected = true
    }
    
    
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        
        if !viewSummary.isHidden {
            showConfirmationPopup(isBuy: false)
            return
        }
        
        for btn in btnProcedures {
            
            btn.tag         = btnProcedures.index(of: btn)!
            btn.isSelected  = false
        }
        
        if selectedProcedure < 3{
            selectedProcedure = selectedProcedure + 1
            collectionProcedures.scrollToItem(at: IndexPath(item: selectedProcedure - 1, section: 0), at: .centeredHorizontally, animated: true)
            
        }else if selectedProcedure < 4{
            selectedProcedure = selectedProcedure + 1
            viewSummary.isHidden = false
            btnNext.setTitle("Pay", for: .normal)
            imgLogo.isHidden = true
        }
        
        btnProcedures[selectedProcedure].isSelected = true
        
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        
        btnNext.setTitle("Next", for: .normal)
        imgLogo.isHidden = false
        
        for btn in btnProcedures {
            btn.tag         = btnProcedures.index(of: btn)!
            btn.isSelected  = false
        }
        
        viewSummary.isHidden = true
        
        if selectedProcedure > 1{
            selectedProcedure = selectedProcedure - 1
            if selectedProcedure < 3{
                collectionProcedures.scrollToItem(at: IndexPath(item: selectedProcedure - 1, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
        
        btnProcedures[selectedProcedure].isSelected = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


// DropDown setups

extension DNSellProceedureVC{
    
    func setupDurationDropDown(sender: UIButton) {
        
        chooseDurationDropDown.anchorView = sender
        
        chooseDurationDropDown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDurationDropDown.dataSource = [
            "Minutes",
            "Hours",
            "Days"
        ]
        
        chooseDurationDropDown.selectionAction = { [weak self] (index, item) in
            //self?.chooseArticleButton.setTitle(item, for: .normal)
            //self?.lblVoulme.text = item + "⌵"
            let cell = self?.collectionProcedures.cellForItem(at: IndexPath(item: 0, section: 0)) as! DNProcedureCollectionCell
            cell.lblDuration.text = item
        }
        
        
    }
    
    
    func setupSpeedDropDown(sender: UIButton) {
        
        chooseSpeedDropDown.anchorView = sender
        
        chooseSpeedDropDown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseSpeedDropDown.dataSource = [
            "kbps",
            "mbps",
            "gbps"
        ]
        
        chooseSpeedDropDown.selectionAction = { [weak self] (index, item) in
            //self?.chooseArticleButton.setTitle(item, for: .normal)
            //self?.lblVoulme.text = item + "⌵"
            let cell = self?.collectionProcedures.cellForItem(at: IndexPath(item: 1, section: 0)) as! DNProcedureCollectionCell
            cell.lblSpeed.text = item
        }
        
        
    }
    
}


extension DNSellProceedureVC: UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DNConstant.ProcedureCellsID.cellsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNConstant.ProcedureCellsID.cellsArray[indexPath.item], for: indexPath) as! DNProcedureCollectionCell
        
        if indexPath.item == 0 {
            cell.btnDuration.addTarget(self, action: #selector(btnDurationTapped(sender:)), for: .touchUpInside)
            setupDurationDropDown(sender: cell.btnDuration)
        }
        
        if indexPath.item == 1 {
            cell.btnSpeed.addTarget(self, action: #selector(btnSpeedTapped(sender:)), for: .touchUpInside)
            setupSpeedDropDown(sender: cell.btnSpeed)
        }
        
        return cell
    }
    
    @objc func btnDurationTapped(sender: UIButton){
        chooseDurationDropDown.show()
        
    }
    
    @objc func btnSpeedTapped(sender: UIButton){
        chooseSpeedDropDown.show()
        
    }
    
}

