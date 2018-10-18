//
//  DNPinVC.swift
//  DoveNetwork
//
//  Created by Reus on 11/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNPinVC: UIViewController
{
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var txtFPin: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
    
    @IBAction func btnContinuePressed(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if txtFPin.text?.trim() == ""
        {
            showAlertViewController(message: "Please enter pin.")
        }
        else
        {
            self.startAnimating()
            
            var parameters:[String:Any] = [:]
            parameters["phone_number"] = getStringUserDefaults(Key: Login_User_phoneNumber)
            parameters["pin"] = txtFPin.text?.trim()
            
            WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServer_POST(reqTask: reqTask_setupPin, dictParameter: parameters as NSDictionary)
        }
    }
}

extension DNPinVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

extension DNPinVC: webServiceDataProviderDelegate
{
    func dataRecievedFromServer(responseData: NSDictionary, withTask reqTask: String)
    {
        self.stopAnimating()
        if reqTask == reqTask_setupPin
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    let userDefaults : UserDefaults = UserDefaults.standard
                    userDefaults.setValue(txtFPin.text?.trim(), forKey: Login_User_pin)
                    userDefaults.synchronize()
                    
                    DNConstant.appDelegate.loadDashboardScreen()
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
