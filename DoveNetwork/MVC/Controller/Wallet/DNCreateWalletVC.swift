//
//  DNCreateWalletVC.swift
//  DoveNetwork
//
//  Created by Reus on 11/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit
import RSBarcodes_Swift

class DNCreateWalletVC: UIViewController
{
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var btnImportWallet: UIButton!
    @IBOutlet weak var btnCreateWallet: UIButton!
    
    @IBOutlet weak var viewPassword: DNRoundView!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var constraintViewPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var txtFPassword: UITextField!
    @IBOutlet weak var btnCreatePassword: UIButton!
    @IBOutlet weak var btnCancelPassword: UIButton!
    
    var dictCreatedWallet: NSMutableDictionary!
    
    var fileURLImportWallet: URL!
    
    var scannerVC: RSCodeReaderViewController! = nil
    
    var isWalletImport: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.constraintViewPasswordHeight.constant = 0
        }
        
        spinner.color = COLOR.spinnerColor
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        viewPassword.isHidden = true
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
    
    @IBAction func btnImportWalletPressed(_ sender: UIButton)
    {
        openImportView()
    }
    
    @IBAction func btnCreateWalletPressed(_ sender: UIButton)
    {
        txtFPassword.text = ""
        btnCreatePassword.setTitle("Create", for: .normal)
        lblPassword.text = "Create wallet"
        self.view.bringSubview(toFront: viewPassword)
        viewPassword.isHidden = false
        constraintViewPasswordHeight.constant = 270
        UIView.animate(withDuration: 0.5)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    func openImportView()
    {
        let importWalletView   = DNConstant.Xibs.importWallet
        importWalletView.frame = (DNConstant.appDelegate.window?.bounds)!
        importWalletView.btnBG.alpha = 0
        importWalletView.clouserActionHandler = {(index) in
            
            importWalletView.removeFromSuperview()
            if index == 0
            {
                // paste copied address
                self.openWalletConfirmation(strAddress: "")
            }
            else if index == 1
            {
                // scan barcode
                
                var strBarcode: String = ""
                var dispatched: Bool = false
                
                self.scannerVC = RSCodeReaderViewController()
                let btnClose: UIButton = UIButton.init(type: UIButtonType.custom)
                btnClose.frame = CGRect(x: 3, y: 20, width: 50, height: 50)
                btnClose.backgroundColor = UIColor.clear
                btnClose.setImage(#imageLiteral(resourceName: "CloseIcon"), for: .normal)
                btnClose.addTarget(self, action: #selector(self.btnCloseScannerPressed), for: .touchUpInside)
                self.scannerVC.view.addSubview(btnClose)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(self.scannerVC, animated: false)
                }
                self.scannerVC.barcodesHandler = { barcodes in
                    if !dispatched
                    {
                        // triggers for only once
                        dispatched = true
                        for barcode in barcodes
                        {
                            guard let barcodeString = barcode.stringValue else { continue }
                            strBarcode = barcodeString
                            print("Barcode found: type=" + barcode.type.rawValue + " value=" + barcodeString)
                            
                            break
                        }
                        DispatchQueue.main.async {
                            self.scannerVC.navigationController?.popViewController(animated: false)
                            self.openWalletConfirmation(strAddress: strBarcode)
                        }
                    }
                }
            }
            else
            {
                // select file
                let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: UIDocumentPickerMode.import)
                documentPicker.delegate = self
                documentPicker.modalPresentationStyle = .formSheet
                self.present(documentPicker, animated: true, completion: nil)
            }
        }
        
        UIView.transition(with: DNConstant.appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {DNConstant.appDelegate.window?.addSubview(importWalletView)}, completion: nil)
    }
    
    @objc func btnCloseScannerPressed()
    {
        scannerVC.navigationController?.popViewController(animated: false)
    }
    
    func openWalletConfirmation(strAddress: String)
    {
        let importWalletConfiramtionView   = DNConstant.Xibs.importWalletConfirmation
        importWalletConfiramtionView.frame = (DNConstant.appDelegate.window?.bounds)!
        importWalletConfiramtionView.btnBG.alpha = 0
        importWalletConfiramtionView.txtFAddress.text = strAddress
        
        importWalletConfiramtionView.actionCompletionHandler = {(index) in
            
            if index == 0
            {
                if importWalletConfiramtionView.txtFAddress.text?.trim() == ""
                {
                    showAlertViewController(message: "Please paste or enter the address.")
                }
                else
                {
                    importWalletConfiramtionView.removeFromSuperview()
                    self.startAnimating()
                    self.importWalletFromAddress(strAddress: "\(importWalletConfiramtionView.txtFAddress.text!)")
                }
            }
            else
            {
                importWalletConfiramtionView.removeFromSuperview()
                self.openImportView()
            }
        }
        
        UIView.transition(with: self.view, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {self.view.addSubview(importWalletConfiramtionView)}, completion: nil)
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
    
    @IBAction func btnCreatePasswordPressed(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if txtFPassword.text?.trim() == ""
        {
            showAlertViewController(message: "Please enter password.")
        }
        else
        {
            if btnCreatePassword.titleLabel?.text == "Create"
            {
                constraintViewPasswordHeight.constant = 0
                UIView.animate(withDuration: 0.5)
                {
                    self.view.layoutIfNeeded()
                }
                self.startAnimating()
                self.createWallet()
            }
            else
            {
                constraintViewPasswordHeight.constant = 0
                UIView.animate(withDuration: 0.5)
                {
                    self.view.layoutIfNeeded()
                }
                
                self.startAnimating()
                self.importWallet()
            }
        }
    }
    
    func createWallet()
    {
        var parameters:[String:Any] = [:]
        parameters["password"] = txtFPassword.text?.trim()
        
        WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServer_POST(reqTask: reqTask_createWallet, dictParameter: parameters as NSDictionary)
    }
    
    func importWallet()
    {
        let dictFile: NSMutableDictionary = NSMutableDictionary()
        let dataTemp: NSData! = NSData(contentsOf: fileURLImportWallet)
        
        let strFileName: String = fileURLImportWallet.path.components(separatedBy: "/").last!
        let strFileType: String = strFileName.components(separatedBy: ".").last!
        
        dictFile.setValue(dataTemp, forKey: "imageData")
        dictFile.setValue("keyfile", forKey: "name")
        dictFile.setValue(strFileName, forKey: "fileName")
        dictFile.setValue("\(strFileType)/\(strFileType)", forKey: "mimeType")
        
        let arrFile: NSMutableArray = NSMutableArray()
        arrFile.add(dictFile)
        
        var parameters:[String:Any] = [:]
        parameters["password"] = txtFPassword.text?.trim()
        
        WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServerWithFile(reqTask: reqTask_importWallet, dictParameter: parameters as NSDictionary, arrFile: arrFile)
    }
    
    func importWalletFromAddress(strAddress: String)
    {
        var parameters:[String:Any] = [:]
        parameters["privateKey"] = strAddress
        
        WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServer_POST(reqTask: reqTask_importWalletFromAddress, dictParameter: parameters as NSDictionary)
    }
    
    func fetchWalletBalance(strAddress: String)
    {
        self.startAnimating()
        
        var parameters:[String:Any] = [:]
        parameters["address"] = strAddress
        
        WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServer_POST(reqTask: reqTask_walletBalance, dictParameter: parameters as NSDictionary)
    }
}

extension DNCreateWalletVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

extension DNCreateWalletVC: webServiceDataProviderDelegate
{
    func dataRecievedFromServer(responseData: NSDictionary, withTask reqTask: String)
    {
        if reqTask == reqTask_createWallet
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    dictCreatedWallet = (responseData[reqData] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    dictCreatedWallet.setValue(txtFPassword.text?.trim(), forKey: Wallet_password)
                    dictCreatedWallet.setValue("1", forKey: Wallet_default)
                    dictCreatedWallet.setValue("1", forKey: Wallet_Type)
                    
                    isWalletImport = false
                    fetchWalletBalance(strAddress: "0X\(dictCreatedWallet.value(forKey: Wallet_publicKey)!)")
                }
                else
                {
                    self.stopAnimating()
                    if let strMsg: String = responseData.value(forKey: reqMessage) as? String
                    {
                        showAlertViewController(message: strMsg)
                    }
                }
            }
        }
        else if reqTask == reqTask_importWallet
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    dictCreatedWallet = (responseData[reqData] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    dictCreatedWallet.setValue(txtFPassword.text?.trim(), forKey: Wallet_password)
                    dictCreatedWallet.setValue("1", forKey: Wallet_default)
                    dictCreatedWallet.setValue("1", forKey: Wallet_Type)
                    
                    isWalletImport = true
                    fetchWalletBalance(strAddress: "0X\(dictCreatedWallet.value(forKey: Wallet_publicKey)!)")
                }
                else
                {
                    self.stopAnimating()
                    if let strMsg: String = responseData.value(forKey: reqMessage) as? String
                    {
                        showAlertViewController(message: strMsg)
                    }
                }
            }
        }
        else if reqTask == reqTask_importWalletFromAddress
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    dictCreatedWallet = (responseData[reqData] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    dictCreatedWallet.setValue("1", forKey: Wallet_default)
                    dictCreatedWallet.setValue("2", forKey: Wallet_Type)
                    
                    isWalletImport = true
                    fetchWalletBalance(strAddress: "0X\(dictCreatedWallet.value(forKey: Wallet_publicKey)!)")
                }
                else
                {
                    self.stopAnimating()
                    if let strMsg: String = responseData.value(forKey: reqMessage) as? String
                    {
                        showAlertViewController(message: strMsg)
                    }
                }
            }
        }
        else if reqTask == reqTask_walletBalance
        {
            self.stopAnimating()
            
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    let dictTemp : NSMutableDictionary = (responseData[reqData] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    let enterNameView   = DNConstant.Xibs.enterNameWallet
                    enterNameView.frame = (DNConstant.appDelegate.window?.bounds)!
                    enterNameView.btnBG.alpha = 0.0
                    enterNameView.txtFEnterName.text = ""
                    enterNameView.lblDove.text = "\(dictTemp.value(forKey: "balance")!) Dove"
                    enterNameView.lblEather.text = "\(dictTemp.value(forKey: "balance")!) Ether"
                    if isWalletImport == true
                    {
                        enterNameView.btnSubmit.setTitle("Import this wallet", for: .normal)
                        enterNameView.btnCancel.setTitle("Import again", for: .normal)
                    }
                    else
                    {
                        enterNameView.btnSubmit.setTitle("Save this wallet", for: .normal)
                        enterNameView.btnCancel.setTitle("Cancel", for: .normal)
                    }
                    enterNameView.actionCompletionHandler = {(index) in
                        
                        if index == 0
                        {
                            if enterNameView.txtFEnterName.text?.trim() == ""
                            {
                                showAlertViewController(message: "Please enter name.")
                            }
                            else
                            {
                                enterNameView.removeFromSuperview()
                                
                                self.dictCreatedWallet.setValue("\(dictTemp.value(forKey: "balance")!)", forKey: Wallet_balance)
                                self.dictCreatedWallet.setValue(enterNameView.txtFEnterName.text?.trim(), forKey: Wallet_name)
                                setDefaultWallet(dictWallet: self.dictCreatedWallet)
                                
                                let walletCreated = DNConstant.StoryBoards.wallet.instantiateViewController(withIdentifier: String(describing: DNWalletCreatedVC.self)) as! DNWalletCreatedVC
                                DispatchQueue.main.async{
                                    self.navigationController?.pushViewController(walletCreated, animated: true)
                                }
                            }
                        }
                        else
                        {
                            enterNameView.removeFromSuperview()
                            if self.isWalletImport == true
                            {
                                self.openImportView()
                            }
                        }
                    }
                    
                    UIView.transition(with: self.view, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                                      animations: {self.view.addSubview(enterNameView)}, completion: nil)
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

extension DNCreateWalletVC: UIDocumentPickerDelegate
{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
        if controller.documentPickerMode == UIDocumentPickerMode.import
        {
            fileURLImportWallet = urls[0]
            txtFPassword.text = ""
            btnCreatePassword.setTitle("Import", for: .normal)
            lblPassword.text = "Import wallet"
            self.view.bringSubview(toFront: viewPassword)
            viewPassword.isHidden = false
            constraintViewPasswordHeight.constant = 270
            UIView.animate(withDuration: 0.5)
            {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    {
    }
}
