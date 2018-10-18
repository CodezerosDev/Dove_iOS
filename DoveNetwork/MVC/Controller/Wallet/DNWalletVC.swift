//
//  DNWalletVC.swift
//  DoveNetwork
//
//  Created by Reus on 13/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit
import RSBarcodes_Swift

class DNWalletVC: UIViewController
{
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var viewDefaultWallet: DNRoundView!
    @IBOutlet weak var btnSwitchWallet: UIButton!
    @IBOutlet weak var lblDove: UILabel!
    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var lblEather: UILabel!

    @IBOutlet weak var viewImportExport: DNRoundView!
    @IBOutlet weak var btnImportWallet: UIButton!
    @IBOutlet weak var btnExportWallet: UIButton!
    
    @IBOutlet weak var viewPassword: DNRoundView!
    @IBOutlet weak var lblExportPassword: UILabel!
    @IBOutlet weak var constraintViewPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var txtFPassword: UITextField!
    @IBOutlet weak var btnExportPassword: UIButton!
    @IBOutlet weak var btnCancelPassword: UIButton!
    
    var viewExportWallet: DNExportWalletView!
    var dictDefaultWallet: NSMutableDictionary!
    
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
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setPresentedNavigationBar(title: "Wallet", largeTitle: true, tranpernt: true, buttonTint: .white)
        viewPassword.isHidden = true
        
        dictDefaultWallet = getDefaultWallet()
        self.assignValues()
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
    
    func assignValues()
    {
        lblDove.text = "\(dictDefaultWallet.value(forKey: Wallet_balance)!)"
        lblEather.text = "\(dictDefaultWallet.value(forKey: Wallet_balance)!) Ether"
        lblWalletName.text = "\(dictDefaultWallet.value(forKey: Wallet_name)!)"
    }
    
    @IBAction func btnSwitchWalletPressed(_ sender: UIButton)
    {
        let walletListVC = DNConstant.StoryBoards.wallet.instantiateViewController(withIdentifier: String(describing: DNWalletListVC.self)) as! DNWalletListVC
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(walletListVC, animated: true)
        }
    }
    
    @IBAction func btnImportWalletPressed(_ sender: UIButton)
    {
        openImportView()
    }
    
    @IBAction func btnExportWalletPressed(_ sender: UIButton)
    {
        if "\(dictDefaultWallet.value(forKey: Wallet_Type)!)" == "1"
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
            viewExportWallet.lblAddress.text = "\(dictDefaultWallet.value(forKey: Wallet_privateKey)!)"
            viewExportWallet.imgViewQR.image = generateQRCode(strText: "\(dictDefaultWallet.value(forKey: Wallet_privateKey)!)")
            viewExportWallet.btnCopyAddress.addTarget(self, action:#selector(btnCopyAddressPressed(_:)), for: .touchUpInside)
            
            UIView.transition(with: DNConstant.appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {DNConstant.appDelegate.window?.addSubview(self.viewExportWallet)}, completion: nil)
        }
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
            if btnExportPassword.titleLabel?.text == "Export"
            {
                let strWalletPassword: String = "\(dictDefaultWallet.value(forKey: Wallet_password)!)"
                
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
    
    func openImportView()
    {
        let importWalletView   = DNConstant.Xibs.importWallet
        importWalletView.frame = (DNConstant.appDelegate.window?.bounds)!
        importWalletView.btnBG.alpha = 0.5
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
                    self.navigationController?.isNavigationBarHidden = true
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
                            self.navigationController?.isNavigationBarHidden = false
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
        self.navigationController?.isNavigationBarHidden = false
        scannerVC.navigationController?.popViewController(animated: false)
    }
    
    func openWalletConfirmation(strAddress: String)
    {
        let importWalletConfiramtionView   = DNConstant.Xibs.importWalletConfirmation
        importWalletConfiramtionView.frame = (DNConstant.appDelegate.window?.bounds)!
        importWalletConfiramtionView.btnBG.alpha = 0.5
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
        parameters["privateKey"] = "\(dictDefaultWallet.value(forKey: Wallet_privateKey)!)"
        parameters["salf"] = "\(dictDefaultWallet.value(forKey: Wallet_salf)!)"
        parameters["iv"] = "\(dictDefaultWallet.value(forKey: Wallet_iv)!)"
        
        WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServer_POST(reqTask: reqTask_exportWallet, dictParameter: parameters as NSDictionary)
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

extension DNWalletVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

extension DNWalletVC: webServiceDataProviderDelegate
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
        else if reqTask == reqTask_importWallet
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    dictDefaultWallet = (responseData[reqData] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    dictDefaultWallet.setValue(txtFPassword.text?.trim(), forKey: Wallet_password)
                    dictDefaultWallet.setValue("1", forKey: Wallet_default)
                    dictDefaultWallet.setValue("1", forKey: Wallet_Type)
                    
                    isWalletImport = true
                    fetchWalletBalance(strAddress: "0X\(dictDefaultWallet.value(forKey: Wallet_publicKey)!)")
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
        else if reqTask == reqTask_importWalletFromAddress
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    dictDefaultWallet = (responseData[reqData] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    dictDefaultWallet.setValue("1", forKey: Wallet_default)
                    dictDefaultWallet.setValue("2", forKey: Wallet_Type)
                    
                    isWalletImport = true
                    fetchWalletBalance(strAddress: "0X\(dictDefaultWallet.value(forKey: Wallet_publicKey)!)")
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
        else if reqTask == reqTask_walletBalance
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    let dictTemp : NSMutableDictionary = (responseData[reqData] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    let enterNameView   = DNConstant.Xibs.enterNameWallet
                    enterNameView.frame = (DNConstant.appDelegate.window?.bounds)!
                    enterNameView.btnBG.alpha = 0.5
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
                                
                                self.dictDefaultWallet.setValue("\(dictTemp.value(forKey: "balance")!)", forKey: Wallet_balance)
                                self.dictDefaultWallet.setValue(enterNameView.txtFEnterName.text?.trim(), forKey: Wallet_name)
                                setDefaultWallet(dictWallet: self.dictDefaultWallet)
                                self.assignValues()
                                showAlertViewController(message: "Import wallet successfully.")
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

extension DNWalletVC: UIDocumentPickerDelegate
{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
        if controller.documentPickerMode == UIDocumentPickerMode.import
        {
            fileURLImportWallet = urls[0]
            txtFPassword.text = ""
            btnExportPassword.setTitle("Import", for: .normal)
            lblExportPassword.text = "Import wallet"
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
            showAlertViewController(message: "Export wallet successfully.")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    {
    }
}
