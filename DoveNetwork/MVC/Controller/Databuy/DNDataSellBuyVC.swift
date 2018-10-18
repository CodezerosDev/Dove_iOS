//
//  DNDataSellBuyVC.swift
//  DoveNetwork
//
//  Created by Reus on 11/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNDataSellBuyVC: UIViewController
{
    @IBOutlet var btnsMenu: [UIButton]!
    @IBOutlet weak var viewContainer: UIView!
    
    var buyTblVC: DNBuyDataTblVC?
    var sellTblVC: DNSellDataTblVC?
    var currentVC: UIViewController?
    
    var boolbuying:Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setCommonNavigationBar(title: "", largeTitle: false, tranpernt: true, buttonTint: .black)
        
        for btn in btnsMenu
        {
            btn.tag = btnsMenu.index(of: btn)!
            btn.addTarget(self, action: #selector(btnMenuTapped(sender:)), for: .touchUpInside)
            btn.isSelected = false
        }
        
        if boolbuying
        {
            btnsMenu[0].isSelected = true
        }
        else
        {
            btnsMenu[1].isSelected = true
        }
        
        initiateChildViewController()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if DNConstant.appDelegate.isBuyPlanRunning
        {
            btnsMenu[1].setTitle("End plan", for: .normal)
        }
        
        if DNConstant.appDelegate.isSellPlanRunning
        {
            btnsMenu[0].setTitle("End plan", for: .normal)
        }
    }
    
    @IBAction func btnWalletTapped(_ sender: UIButton)
    {
        let walletVC = DNConstant.StoryBoards.wallet.instantiateViewController(withIdentifier: String(describing: DNWalletVC.self)) as! DNWalletVC
        APPLICATION_DELEGATE.navController = UINavigationController(rootViewController: walletVC)
        DispatchQueue.main.async {
            self.present(APPLICATION_DELEGATE.navController!, animated: true, completion: nil)
        }
    }
    
    @objc func btnMenuTapped(sender: UIButton)
    {
        switch sender.tag
        {
        case 0:
            if !DNConstant.appDelegate.isSellPlanRunning
            {
                displayCurrentTab(currentVC: buyTblVC!)
            }
            else
            {
                DNConstant.appDelegate.isSellPlanRunning = false
                DNConstant.appDelegate.isBuyPlanRunning = false
                btnsMenu[0].setTitle("Buy Data", for: .normal)
                initiateChildViewController()
                
                for btn in btnsMenu
                {
                    btn.isSelected = false
                }
                
                if boolbuying
                {
                    btnsMenu[0].isSelected = true
                }
                else
                {
                    btnsMenu[1].isSelected = true
                }
                initiateChildViewController()
                
                return
            }
            break
            
        case 1:
            if !DNConstant.appDelegate.isBuyPlanRunning
            {
                displayCurrentTab(currentVC: sellTblVC!)
            }
            else
            {
                DNConstant.appDelegate.isBuyPlanRunning = false
                DNConstant.appDelegate.isSellPlanRunning = false
                btnsMenu[1].setTitle("Sell Data", for: .normal)
                initiateChildViewController()
                
                for btn in btnsMenu
                {
                    btn.isSelected = false
                }
                
                if boolbuying
                {
                    btnsMenu[0].isSelected = true
                }
                else
                {
                    btnsMenu[1].isSelected = true
                }
                
                initiateChildViewController()
                return
            }
            break
            
        default:
            break
        }
        
        for btn in btnsMenu
        {
            btn.isSelected = false
        }
        sender.isSelected = true
    }
}

extension DNDataSellBuyVC
{
    func initiateChildViewController() -> Void
    {
        buyTblVC = storyboard!.instantiateViewController(withIdentifier: String(describing: DNBuyDataTblVC.self)) as? DNBuyDataTblVC
        addChildViewController(buyTblVC!)
        sellTblVC = DNConstant.StoryBoards.sellData.instantiateViewController(withIdentifier: String(describing: DNSellDataTblVC.self)) as? DNSellDataTblVC
        addChildViewController(sellTblVC!)
        addSubview(subView: boolbuying ? buyTblVC!.view : sellTblVC!.view, toView: viewContainer)
    }
    
    func addSubview(subView:UIView, toView parentView:UIView)
    {
        parentView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subView]-0-|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subView]-0-|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func displayCurrentTab(currentVC:UIViewController)
    {
        if currentVC != self.currentVC
        {
            self.addChildViewController(currentVC)
            currentVC.didMove(toParentViewController: self)
            currentVC.view.frame = self.viewContainer.bounds
            addSubview(subView: currentVC.view, toView: viewContainer)
            currentVC.viewWillAppear(true)
            self.currentVC = currentVC
        }
    }
}


