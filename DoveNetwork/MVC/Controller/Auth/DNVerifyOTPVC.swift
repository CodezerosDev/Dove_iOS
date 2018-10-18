//
//  DNVerifyOTPVC.swift
//  DoveNetwork
//
//  Created by Reus on 07/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit
import CTKFlagPhoneNumber

class DNVerifyOTPVC: UIViewController
{
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var txtFPhoneNumber: CTKFlagPhoneNumberTextField!
    
    @IBOutlet var txtFOTP: KWTextFieldView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var btnResendOTP: UIButton!
    @IBOutlet var btnEditNumber: UIButton!
    @IBOutlet var btnContinue: UIButton!
    
    var strUserVarificationStatus: String!
    var strCountryCode: String!
    var strNumber: String!
    var strPhoneNumber: String!
    var strUserID: String!
    var strAuthToken: String!
    var strOTP: String!
    var timerResendOTP: Timer!
    var time: Int! = 30
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnResendOTP.isHidden = true
        lblTime.text = "00:\(time!)"
        timerResendOTP = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(DNVerifyOTPVC.setTimer), userInfo: nil, repeats: true)
        
        spinner.color = COLOR.spinnerColor
        
        txtFOTP.numberTextField.text = strOTP!
        txtFPhoneNumber.setFlag(for: strCountryCode!)
        txtFPhoneNumber.set(phoneNumber: strNumber!)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setCommonNavigationBar(title: "Verification", largeTitle: true, tranpernt: true, buttonTint: .white)
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
    
    @objc func setTimer()
    {
        if time > 0
        {
            time = time - 1
            
            if time <= 9
            {
                lblTime.text = "00:0\(time!)"
            }
            else
            {
                lblTime.text = "00:\(time!)"
            }
        }
        else
        {
            time = 00
            timerResendOTP.invalidate()
            
            lblTime.text = "00:00"
            
            lblTime.isHidden = true
            btnResendOTP.isHidden = false
        }
    }
    
    @IBAction func btnResendOTPPressed(_ sender: UIButton)
    {
        self.startAnimating()
        
        var parameters:[String:Any] = [:]
        parameters["phone_number"] = strPhoneNumber
        
        WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServer_POST(reqTask: reqTask_resendOTP, dictParameter: parameters as NSDictionary)
    }
    
    @IBAction func btnEditNumberPressed(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinuePressed(_ sender: UIButton)
    {
        var strMsg : String = ""
        
        if txtFOTP.code! == ""
        {
            strMsg = "OTP is required."
        }
        else if timerResendOTP.isValid == false
        {
            strMsg = "OTP has been expired."
        }
        else if txtFOTP.code! != strOTP!
        {
            strMsg = "OTP does not match."
        }
        
        if strMsg == ""
        {
            self.startAnimating()
            
            var parameters:[String:Any] = [:]
            parameters["phone_number"] = strPhoneNumber
            parameters["user_id"] = strUserID
            parameters["verification_code"] = txtFOTP.code!
            
            WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServer_POST(reqTask: reqTask_registerStep2, dictParameter: parameters as NSDictionary)
        }
        else
        {
            showAlertViewController(message: strMsg)
        }
    }
}

extension DNVerifyOTPVC: webServiceDataProviderDelegate
{
    func dataRecievedFromServer(responseData: NSDictionary, withTask reqTask: String)
    {
        self.stopAnimating()
        if reqTask == reqTask_resendOTP
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    let dictData: NSDictionary = responseData.value(forKey: reqData)! as! NSDictionary
                    strOTP = "\(dictData.value(forKey: "verification_code")!)"
                    strPhoneNumber = "\(dictData.value(forKey: "phone_number")!)"
                    strUserID = "\(dictData.value(forKey: "user_id")!)"
                    txtFOTP.numberTextField.text = strOTP!
                    
                    timerResendOTP.invalidate()
                    time = 30
                    lblTime.text = "00:\(time!)"
                    lblTime.isHidden = false
                    btnResendOTP.isHidden = true
                    timerResendOTP = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(DNVerifyOTPVC.setTimer), userInfo: nil, repeats: true)
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
        else if reqTask == reqTask_registerStep2
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    let userDefaults : UserDefaults = UserDefaults.standard
                    
                    let dictTemp : NSDictionary = (responseData[reqData] as! NSDictionary).mutableCopy() as! NSDictionary
                    userDefaults.setValue("\(dictTemp.value(forKey: "user_id")!)", forKey: Login_User_user_id)
                    userDefaults.setValue(strAuthToken!, forKey: Login_User_auth_token)
                    userDefaults.setValue("\(dictTemp.value(forKey: "phone_number")!)", forKey: Login_User_phoneNumber)
                    userDefaults.synchronize()
                    
                    if isKeyPresentInUserDefaults(key: Login_User_walletList)
                    {
                        if isKeyPresentInUserDefaults(key: Login_User_pin)
                        {
                            DNConstant.appDelegate.loadDashboardScreen()
                        }
                        else
                        {
                            DNConstant.appDelegate.loadSetUpPinScreen()
                        }
                    }
                    else
                    {
                        DNConstant.appDelegate.loadWalletScreen()
                    }
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
