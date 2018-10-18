//
//  UIViewController+Properties.swift
//  DoveNetwork
//
//  Created by Reus on 07/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func setCommonNavigationBar(title:String, largeTitle:Bool, tranpernt:Bool, buttonTint: UIColor)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title  = NSLocalizedString(title, comment: "")
        self.navigationController?.navigationBar.tintColor    = buttonTint
        self.navigationController?.navigationBar.barTintColor = buttonTint
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:buttonTint, NSAttributedStringKey.font: UIFont(name: "Poppins-Medium", size: 24.0)!]
        
        self.navigationItem.hidesBackButton = true
        
        let backDrawerMenu:UIBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "backIcon"), style: .plain, target: self, action: #selector(UIViewController.backTapped))
        backDrawerMenu.tintColor = buttonTint
        self.navigationItem.leftBarButtonItem = backDrawerMenu
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = largeTitle
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:buttonTint, NSAttributedStringKey.font: UIFont(name: "Poppins-SemiBold", size: 30.0)!]
        
        if tranpernt
        {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = UIColor.clear
        }
    }
    
    func setPresentedNavigationBar(title:String, largeTitle:Bool, tranpernt:Bool, buttonTint: UIColor)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title  = NSLocalizedString(title, comment: "")
        self.navigationController?.navigationBar.tintColor    = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:buttonTint, NSAttributedStringKey.font: UIFont(name: "Poppins-Medium", size: 24.0)!]
        
        
        self.navigationItem.hidesBackButton = true
        
        let backDrawerMenu:UIBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "CloseIcon"), style: .plain, target: self, action: #selector(UIViewController.crossTapped))
        backDrawerMenu.tintColor = buttonTint
        self.navigationItem.leftBarButtonItem = backDrawerMenu
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = largeTitle
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:buttonTint, NSAttributedStringKey.font: UIFont(name: "Poppins-SemiBold", size: 30.0)!]
        
        if tranpernt
        {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = UIColor.clear
        }
    }
    
    func setFlipNavigationBar(title:String, largeTitle:Bool, tranpernt:Bool, buttonTint: UIColor)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title  = NSLocalizedString(title, comment: "")
        self.navigationController?.navigationBar.tintColor    = buttonTint
        self.navigationController?.navigationBar.barTintColor = buttonTint
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:buttonTint, NSAttributedStringKey.font: UIFont(name: "Poppins-Medium", size: 24.0)!]
        
        self.navigationItem.hidesBackButton = true
        
        let backDrawerMenu:UIBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "backIcon"), style: .plain, target: self, action: #selector(UIViewController.flipBack))
        backDrawerMenu.tintColor = buttonTint
        self.navigationItem.leftBarButtonItem = backDrawerMenu
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = largeTitle
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:buttonTint, NSAttributedStringKey.font: UIFont(name: "Poppins-SemiBold", size: 30.0)!]
        
        if tranpernt
        {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = UIColor.clear
        }
    }
    
    @objc func crossTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backTapped()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func flipBack()
    {
        UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromRight, animations: {
            _ = self.navigationController?.popViewController(animated: false)
        }, completion: nil)
    }
    
    func showConfirmationPopup(isBuy:Bool)
    {
        let confirmationView   = DNConstant.Xibs.confirmation
        confirmationView.frame = (DNConstant.appDelegate.window?.bounds)!
        
        confirmationView.clouserBtnTapped = {(index) in
            confirmationView.removeFromSuperview()
            
            if index == 0
            {
                if isBuy
                {
                    DNConstant.appDelegate.isBuyPlanRunning = true
                }
                else
                {
                    DNConstant.appDelegate.isSellPlanRunning = true
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        UIView.transition(with: DNConstant.appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {DNConstant.appDelegate.window?.addSubview(confirmationView)}, completion: nil)
    }
    
    func showDeletePopup()
    {
        let confirmationView   = DNConstant.Xibs.confirmation
        confirmationView.frame = (DNConstant.appDelegate.window?.bounds)!
        
        confirmationView.setTitle       = "Confirm delete?"
        confirmationView.setMessage     = "Are you want to delete plan Economy - 350?"
        confirmationView.btnColor       = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 143.0/255.0, alpha: 1)
        confirmationView.setbuttonTitle = "Delete"
        
        confirmationView.clouserBtnTapped = {(index) in
            confirmationView.removeFromSuperview()
            
            if index == 0
            {
                self.dismiss(animated: true, completion: nil)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        UIView.transition(with: DNConstant.appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {DNConstant.appDelegate.window?.addSubview(confirmationView)}, completion: nil)
    }
    
    func showHistoryDetails()
    {
        let historyDetailView   = DNConstant.Xibs.historyDetail
        historyDetailView.frame = (DNConstant.appDelegate.window?.bounds)!
        
        UIView.transition(with: DNConstant.appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {DNConstant.appDelegate.window?.addSubview(historyDetailView)}, completion: nil)
    }
    
    
}


extension UITableView
{
    func animateTable()
    {
        self.reloadData()
        
        let cells = self.visibleCells
        let tableHeight: CGFloat = self.bounds.size.height
        
        for i in cells
        {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells
        {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    func animateHorizontally()
    {
        self.reloadData()
        
        let cells = self.visibleCells
        // let tableHeight: CGFloat = self.bounds.size.height
        let tableWidth: CGFloat = self.bounds.size.height
        
        for i in cells
        {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: -tableWidth, y: 0)
        }
        
        var index = 0
        
        for a in cells
        {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.06 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
}

