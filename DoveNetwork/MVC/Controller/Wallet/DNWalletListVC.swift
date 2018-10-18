//
//  DNWalletListVC.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNWalletListVC: UIViewController
{
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tblWalletList: UITableView!
    
    @IBOutlet weak var viewPassword: DNRoundView!
    @IBOutlet weak var lblExportPassword: UILabel!
    @IBOutlet weak var constraintViewPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var txtFPassword: UITextField!
    @IBOutlet weak var btnExportPassword: UIButton!
    @IBOutlet weak var btnCancelPassword: UIButton!
    
    var viewExportWallet: DNExportWalletView!
    
    var arrWalletList: NSMutableArray!
    var dictSelectedWallet: NSMutableDictionary!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblWalletList.dataSource = self
        tblWalletList.delegate = self
        viewPassword.isHidden = true
        
        arrWalletList = getWalletList()
        
        DispatchQueue.main.async {
            self.tblWalletList.animateHorizontally()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setCommonNavigationBar(title: "Wallets", largeTitle: true, tranpernt: false, buttonTint: .white)
    }
    
    func startAnimating()
    {
        self.view.isUserInteractionEnabled = false
        self.view.bringSubview(toFront: spinner)
        spinner.startAnimating()
    }
    
    func stopAnimating()
    {
        spinner.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    @IBAction func btnCancelPasswordPressed(_ sender: UIButton)
    {
        self.view.endEditing(true)
        constraintViewPasswordHeight.constant = 0
        UIView.animate(withDuration: 0.5)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnExportPasswordPressed(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if txtFPassword.text?.trim() == ""
        {
            showAlertViewController(message: "Please enter password.")
        }
        else
        {
            let strWalletPassword: String = "\(dictSelectedWallet.value(forKey: Wallet_password)!)"
            
            if strWalletPassword == txtFPassword.text?.trim()
            {
                constraintViewPasswordHeight.constant = 0
                UIView.animate(withDuration: 0.5)
                {
                    self.view.layoutIfNeeded()
                }
                self.startAnimating()
                self.exportWallet()
            }
            else
            {
                showAlertViewController(message: "Invalid password.")
            }
        }
    }
    
    func deleteWallet()
    {
        let deleteWalletView   = DNConstant.Xibs.deleteWallet
        deleteWalletView.frame = (DNConstant.appDelegate.window?.bounds)!
        
        deleteWalletView.actionCompletionHandler = {(index) in
            
            if index == 0
            {
                deleteWalletView.removeFromSuperview()
                self.arrWalletList.remove(self.dictSelectedWallet)
                
                if "\(self.dictSelectedWallet.value(forKey: Wallet_default)!)" == "1"
                {
                    let dictActive: NSMutableDictionary = (self.arrWalletList.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    dictActive.setValue("1", forKey: Wallet_default)
                    self.arrWalletList.replaceObject(at: 0, with: dictActive)
                }
                saveWalletList(arrList: self.arrWalletList)
                self.tblWalletList.reloadData()
            }
            else
            {
                deleteWalletView.removeFromSuperview()
            }
        }
        
        UIView.transition(with: DNConstant.appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {DNConstant.appDelegate.window?.addSubview(deleteWalletView)}, completion: nil)
    }
    
    func saveFile(dictData: NSDictionary)
    {
        let fileManager = FileManager.default
        do
        {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            var fileURL = documentDirectory.appendingPathComponent("DoveNetwork")
            
            if fileManager.fileExists(atPath: fileURL.path) == false
            {
                try fileManager.createDirectory(atPath: fileURL.path, withIntermediateDirectories: false, attributes: nil)
            }
            let strFileName: String = "UTC--\(getCurrentISODateString())--\(dictData.value(forKey: "address")!)"
            fileURL = fileURL.appendingPathComponent(strFileName)
            
            try dictData.JSONString().write(toFile: fileURL.path, atomically: true, encoding: String.Encoding.utf8.rawValue)
            print("\(fileURL.path)")
            
            let documentPicker = UIDocumentPickerViewController(url: fileURL, in: .exportToService)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
        }
        catch
        {
            print(error)
        }
    }
    
    @IBAction func btnCopyAddressPressed(_ sender: UIButton)
    {
        UIPasteboard.general.string = viewExportWallet.lblAddress.text!
        viewExportWallet.removeFromSuperview()
    }
    
    func exportWallet()
    {
        var parameters:[String:Any] = [:]
        parameters["password"] = txtFPassword.text?.trim()
        parameters["privateKey"] = "\(dictSelectedWallet.value(forKey: Wallet_privateKey)!)"
        parameters["salf"] = "\(dictSelectedWallet.value(forKey: Wallet_salf)!)"
        parameters["iv"] = "\(dictSelectedWallet.value(forKey: Wallet_iv)!)"
        
        WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServer_POST(reqTask: reqTask_exportWallet, dictParameter: parameters as NSDictionary)
    }
}

extension DNWalletListVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrWalletList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DNWalletListTblCell.self)) as! DNWalletListTblCell
        
        cell.dictWallet = arrWalletList.object(at: indexPath.row) as! NSDictionary
        cell.reloadWalletListCell()
        
        cell.btnActive.tag = indexPath.row
        cell.btnActive.addTarget(self, action: #selector(btnActivePressed(sender:)), for: .touchUpInside)
        
        cell.btnExport.tag = indexPath.row
        cell.btnExport.addTarget(self, action: #selector(btnExportPressed(sender:)), for: .touchUpInside)
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(btnRemovePressed(sender:)), for: .touchUpInside)
        
        if arrWalletList.count == 1
        {
            cell.btnRemove.isHidden = true
        }
        else
        {
            cell.btnRemove.isHidden = false
        }
        return cell
    }
    
    @objc func btnActivePressed(sender: UIButton)
    {
        dictSelectedWallet = (arrWalletList.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        if "\(dictSelectedWallet.value(forKey: Wallet_default)!)" != "1"
        {
            dictSelectedWallet.setValue("1", forKey: Wallet_default)
            for i in 0..<arrWalletList.count
            {
                let dictTemp: NSMutableDictionary = (arrWalletList.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                if "\(dictTemp.value(forKey: Wallet_default)!)" == "1"
                {
                    dictTemp.setValue("0", forKey: Wallet_default)
                    arrWalletList.replaceObject(at: i, with: dictTemp)
                }
            }
            arrWalletList.replaceObject(at: sender.tag, with: dictSelectedWallet)
            saveWalletList(arrList: arrWalletList)
            tblWalletList.reloadData()
        }
    }
    
    @objc func btnExportPressed(sender: UIButton)
    {
        dictSelectedWallet = (arrWalletList.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        if "\(dictSelectedWallet.value(forKey: Wallet_Type)!)" == "1"
        {
            txtFPassword.text = ""
            btnExportPassword.setTitle("Export", for: .normal)
            lblExportPassword.text = "Export wallet"
            self.view.bringSubview(toFront: viewPassword)
            viewPassword.isHidden = false
            constraintViewPasswordHeight.constant = 270
            UIView.animate(withDuration: 0.5)
            {
                self.view.layoutIfNeeded()
            }
        }
        else
        {
            viewExportWallet = DNConstant.Xibs.exportWallet
            viewExportWallet.btnBG.alpha = 0.5
            viewExportWallet.frame = (DNConstant.appDelegate.window?.bounds)!
            viewExportWallet.lblAddress.text = "\(dictSelectedWallet.value(forKey: Wallet_privateKey)!)"
            viewExportWallet.imgViewQR.image = generateQRCode(strText: "\(dictSelectedWallet.value(forKey: Wallet_privateKey)!)")
            viewExportWallet.btnCopyAddress.addTarget(self, action:#selector(btnCopyAddressPressed(_:)), for: .touchUpInside)
            
            UIView.transition(with: DNConstant.appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {DNConstant.appDelegate.window?.addSubview(self.viewExportWallet)}, completion: nil)
        }
    }
    
    @objc func btnRemovePressed(sender: UIButton)
    {
        dictSelectedWallet = (arrWalletList.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        deleteWallet()
    }
}

extension DNWalletListVC: webServiceDataProviderDelegate
{
    func dataRecievedFromServer(responseData: NSDictionary, withTask reqTask: String)
    {
        self.stopAnimating()
        if reqTask == reqTask_exportWallet
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    let dictTemp : NSDictionary = (responseData[reqData] as! NSDictionary).mutableCopy() as! NSDictionary
                    self.saveFile(dictData: dictTemp)
                }
                else
                {
                    if let strMsg: String = responseData.value(forKey: reqMessage) as? String
                    {
                        showAlertViewController(message: strMsg)
                    }
                }
            }
        }
    }
}

extension DNWalletListVC: UIDocumentPickerDelegate
{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
        showAlertViewController(message: "Export wallet successfully.")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    {
    }
}

extension DNWalletListVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
