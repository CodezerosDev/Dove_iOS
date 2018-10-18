//
//  DNRegisterVC.swift
//  DoveNetwork
//
//  Created by Reus on 07/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit
import CTKFlagPhoneNumber

class DNRegisterVC: UIViewController
{
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var txtFPhoneNumber: CTKFlagPhoneNumberTextField!
    
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
        setCommonNavigationBar(title: "Register", largeTitle: true, tranpernt: true, buttonTint: .white)
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
    
    @IBAction func btnContinueTapped(_ sender: UIButton)
    {
        if txtFPhoneNumber.text?.isEmpty == true
        {
            showAlertViewController(message: "Please enter phone number.")
        }
        else if txtFPhoneNumber.getRawPhoneNumber() == nil
        {
            showAlertViewController(message: "Invalid phone number.")
        }
        else
        {
            self.startAnimating()

            var strPhone: String = txtFPhoneNumber.getFormattedPhoneNumber()!
            strPhone = strPhone.replacingOccurrences(of: "+", with: "")

            var parameters:[String:Any] = [:]
            parameters["phone_number"] = strPhone
            parameters["app_device"] = DEVICE_TYPE
            parameters["device_id"] = DEVICE_ID

            WebServiceDataProvider.sharedInstanceWithDelegate(delgate: self).sendRequestToServer_POST(reqTask: reqTask_registerStep1, dictParameter: parameters as NSDictionary)
        }
    }
}

extension DNRegisterVC: webServiceDataProviderDelegate
{
    func dataRecievedFromServer(responseData: NSDictionary, withTask reqTask: String)
    {
        self.stopAnimating()
        if reqTask == reqTask_registerStep1
        {
            if let status: Int = responseData.value(forKey: reqStatus_code)! as? Int
            {
                if status == 1
                {
                    var strPhone: String = txtFPhoneNumber.getFormattedPhoneNumber()!
                    strPhone = strPhone.replacingOccurrences(of: "+", with: "")
                    
                    let dictData: NSDictionary = responseData.value(forKey: reqData)! as! NSDictionary
                    let verifyOTP   = DNConstant.StoryBoards.authentication.instantiateViewController(withIdentifier: String(describing: DNVerifyOTPVC.self)) as! DNVerifyOTPVC
                    verifyOTP.strOTP = "\(dictData.value(forKey: "verification_code")!)"
                    verifyOTP.strPhoneNumber = strPhone
                    verifyOTP.strCountryCode = txtFPhoneNumber.getCountryCode()!
                    verifyOTP.strNumber = txtFPhoneNumber.getRawPhoneNumber()!
                    verifyOTP.strUserID = "\(dictData.value(forKey: "user_id")!)"
                    verifyOTP.strAuthToken = "\(dictData.value(forKey: "auth_token")!)"
                    verifyOTP.strUserVarificationStatus = "\(dictData.value(forKey: "user_verification_status")!)"
                    
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(verifyOTP, animated: true)
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
