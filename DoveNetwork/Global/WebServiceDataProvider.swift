//
//  WebServiceDataProvider.swift
//  Genemobility
//
//  Created by webclues-mac on 12/04/18.
//  Copyright © 2018 webclues-mac. All rights reserved.
//

import UIKit
import AFNetworking

protocol webServiceDataProviderDelegate
{
    func dataRecievedFromServer(responseData: NSDictionary, withTask reqTask: String)
}

class WebServiceDataProvider: NSObject
{
    var delegate : webServiceDataProviderDelegate?
    
    class var sharedInstance: WebServiceDataProvider
    {
        struct Static
        {
            static let instance = WebServiceDataProvider()
        }
        return Static.instance
    }
    
    class func sharedInstanceWithDelegate (delgate : webServiceDataProviderDelegate) -> WebServiceDataProvider
    {
        sharedInstance.delegate = delgate
        return sharedInstance
    }
    
    func sendRequestToServer_POST (reqTask: String!, dictParameter: NSDictionary)
    {
        if isInternetAvailable()
        {
            var strURL: String = ""
            if reqTask == reqTask_createWallet || reqTask == reqTask_exportWallet || reqTask == reqTask_walletBalance || reqTask == reqTask_importWallet || reqTask == reqTask_importWalletFromAddress
            {
                strURL = "\(SERVER_URL1)\(reqTask!)"
            }
            else
            {
                strURL = "\(SERVER_URL)\(reqTask!)"
            }
            
            //let strURL: String = "\(SERVER_URL)\(reqTask!)"
            print("ServerURL:- \(strURL)")
            print("RequestObj:- \(dictParameter.JSONString())")
            
            let manager = AFHTTPSessionManager()
            
            let dictUser: NSDictionary! = getLoginUserDict()
            if dictUser.allKeys.count > 0
            {
                let strAuthToken : String! = "\(dictUser.value(forKey: Login_User_auth_token)!)"
                let strUserID : String! = "\(dictUser.value(forKey: Login_User_user_id)!)"
                
                if strUserID.count > 0 && strAuthToken.count > 0
                {
                    manager.requestSerializer.setValue(strAuthToken!, forHTTPHeaderField: "Authorizations")
                    manager.requestSerializer.setValue(strUserID!, forHTTPHeaderField: "userid")
                }
                print("HeaderField:- Authorizations : \(strAuthToken!) userid : \(strUserID!) ")
            }
    
            manager.post(strURL, parameters: dictParameter, progress: nil, success: {(URLSessionDataTask, responseObject: Any) -> Void in
                
                print("Response Success:- \(responseObject)")
                
                if self.delegate != nil
                {
                    if reqTask != nil
                    {
                        if let statusCode: Int = (responseObject as! NSDictionary).value(forKey: reqStatus_code)! as? Int
                        {
                            if statusCode == 100
                            {
                                var errorDict: [String : AnyObject] = [:]
                                errorDict[reqStatus_code] = 1111 as AnyObject
                                self.delegate!.dataRecievedFromServer(responseData: errorDict as NSDictionary, withTask: reqTask)
                            }
                            else
                            {
                                self.delegate!.dataRecievedFromServer(responseData: responseObject as! NSDictionary, withTask: reqTask)
                            }
                        }
                        else
                        {
                            self.delegate!.dataRecievedFromServer(responseData: responseObject as! NSDictionary, withTask: reqTask)
                        }
                    }
                }
                
            }, failure: {(URLSessionDataTask, error: Any) -> Void in
                
                print("Response Error:- \(error)")
                
                if self.delegate != nil
                {
                    var errorDict: [String : AnyObject] = [:]
                    errorDict[reqStatus_code] = 1111 as AnyObject
                    errorDict[reqMessage] = "Server is down, Please try after some time." as AnyObject

                    if reqTask != nil
                    {
                        self.delegate!.dataRecievedFromServer(responseData: errorDict as NSDictionary, withTask: reqTask)
                    }
                }
            })
        }
        else
        {
            var errorDict: [String : AnyObject] = [:]
            errorDict[reqStatus_code] = 1111 as AnyObject
            
            if reqTask != nil
            {
                self.delegate!.dataRecievedFromServer(responseData: errorDict as NSDictionary, withTask: reqTask)
            }
            showNoInternetConnection()
        }
    }
    
    func sendRequestToServer_GET (reqTask: String!, dictParameter: NSDictionary)
    {
        if isInternetAvailable()
        {
            let strURL: String = "\(SERVER_URL)\(reqTask!)"
            print("ServerURL:- \(strURL)")
            print("RequestObj:- \(dictParameter.JSONString())")
            
            let manager = AFHTTPSessionManager()
            
            let dictUser: NSDictionary! = getLoginUserDict()
            if dictUser.allKeys.count > 0
            {
                let strAuthToken : String! = "\(dictUser.value(forKey: Login_User_auth_token)!)"
                let strUserID : String! = "\(dictUser.value(forKey: Login_User_user_id)!)"
                
                if strUserID.count > 0 && strAuthToken.count > 0
                {
                    manager.requestSerializer.setValue(strAuthToken!, forHTTPHeaderField: "Authorizations")
                    manager.requestSerializer.setValue(strUserID!, forHTTPHeaderField: "userid")
                }
                print("HeaderField:- Authorizations : \(strAuthToken!) userid : \(strUserID!) ")
            }
    
            manager.get(strURL, parameters: dictParameter, progress: nil, success: {(URLSessionDataTask, responseObject: Any) -> Void in
                
                print("Response Success:- \(responseObject)")
                
                if self.delegate != nil
                {
                    if reqTask != nil
                    {
                        if let statusCode: Int = (responseObject as! NSDictionary).value(forKey: reqStatus_code)! as? Int
                        {
                            if statusCode == 100
                            {
                                var errorDict: [String : AnyObject] = [:]
                                errorDict[reqStatus_code] = 1111 as AnyObject
                                self.delegate!.dataRecievedFromServer(responseData: errorDict as NSDictionary, withTask: reqTask)
                            }
                            else
                            {
                                self.delegate!.dataRecievedFromServer(responseData: responseObject as! NSDictionary, withTask: reqTask)
                            }
                        }
                        else
                        {
                            self.delegate!.dataRecievedFromServer(responseData: responseObject as! NSDictionary, withTask: reqTask)
                        }
                    }
                }
                
            }, failure: {(URLSessionDataTask, error: Any) -> Void in
                
                print("Response Error:- \(error)")
                
                if self.delegate != nil
                {
                    var errorDict: [String : AnyObject] = [:]
                    errorDict[reqStatus_code] = 1111 as AnyObject
                    errorDict[reqMessage] = "Server is down, Please try after some time." as AnyObject
                    
                    if reqTask != nil
                    {
                        self.delegate!.dataRecievedFromServer(responseData: errorDict as NSDictionary, withTask: reqTask)
                    }
                }
            })
        }
        else
        {
            var errorDict: [String : AnyObject] = [:]
            errorDict[reqStatus_code] = 1111 as AnyObject
            
            if reqTask != nil
            {
                self.delegate!.dataRecievedFromServer(responseData: errorDict as NSDictionary, withTask: reqTask)
            }
            showNoInternetConnection()
        }
    }
    
    
    func sendRequestToServerWithFile (reqTask: String!, dictParameter: NSDictionary, arrFile: NSMutableArray)
    {
        if isInternetAvailable()
        {
            var strURL: String = ""
            if reqTask == reqTask_createWallet || reqTask == reqTask_exportWallet || reqTask == reqTask_walletBalance || reqTask == reqTask_importWallet
            {
                strURL = "\(SERVER_URL1)\(reqTask!)"
            }
            else
            {
                strURL = "\(SERVER_URL)\(reqTask!)"
            }
            
            print("ServerURL:- \(strURL)")
            print("RequestObj:- \(dictParameter.JSONString())")
            
            let manager = AFHTTPSessionManager()
            
            let dictUser: NSDictionary! = getLoginUserDict()
            if dictUser.allKeys.count > 0
            {
                let strAuthToken : String! = "\(dictUser.value(forKey: Login_User_auth_token)!)"
                let strUserID : String! = "\(dictUser.value(forKey: Login_User_user_id)!)"
                
                if strUserID.count > 0 && strAuthToken.count > 0
                {
                    manager.requestSerializer.setValue(strAuthToken!, forHTTPHeaderField: "Authorizations")
                    manager.requestSerializer.setValue(strUserID!, forHTTPHeaderField: "userid")
                }
                print("HeaderField:- Authorizations : \(strAuthToken!) userid : \(strUserID!) ")
            }
            
            manager.post(strURL, parameters: dictParameter, constructingBodyWith: {(formData: AFMultipartFormData) -> Void in
                
                if arrFile.count > 0
                {
                    for i in 0..<arrFile.count
                    {
                        let dictTemp : NSMutableDictionary = arrFile.object(at: i) as! NSMutableDictionary
                        
                        let imageData : NSData = dictTemp.value(forKey: "imageData") as! NSData
                        let name : String = dictTemp.value(forKey: "name") as! String
                        let fileName : String = dictTemp.value(forKey: "fileName") as! String
                        let mimeType : String = dictTemp.value(forKey: "mimeType") as! String
                        
                        formData.appendPart(withFileData: imageData as Data, name: name, fileName: fileName, mimeType: mimeType)
                    }
                }
                
            }, progress: nil, success: {(URLSessionDataTask, responseObject:Any) -> Void in
                
                print("Response Success:- \(responseObject)")
                
                if self.delegate != nil
                {
                    if reqTask != nil
                    {
                        if let statusCode: Int = (responseObject as! NSDictionary).value(forKey: reqStatus_code)! as? Int
                        {
                            if statusCode == 100
                            {
                                var errorDict: [String : AnyObject] = [:]
                                errorDict[reqStatus_code] = 1111 as AnyObject
                                self.delegate!.dataRecievedFromServer(responseData: errorDict as NSDictionary, withTask: reqTask)
                            }
                            else
                            {
                                self.delegate!.dataRecievedFromServer(responseData: responseObject as! NSDictionary, withTask: reqTask)
                            }
                        }
                        else
                        {
                            self.delegate!.dataRecievedFromServer(responseData: responseObject as! NSDictionary, withTask: reqTask)
                        }
                    }
                }
                
            }, failure: {(URLSessionDataTask, error: Any) -> Void in
                
                print("Response Error:- \(error)")
                
                if self.delegate != nil
                {
                    var errorDict: [String : AnyObject] = [:]
                    errorDict[reqStatus_code] = 1111 as AnyObject
                    errorDict[reqMessage] = "Server is down, Please try after some time." as AnyObject
                    
                    if reqTask != nil
                    {
                        self.delegate!.dataRecievedFromServer(responseData: errorDict as NSDictionary, withTask: reqTask)
                    }
                }
            })
        }
        else
        {
            var errorDict: [String : AnyObject] = [:]
            errorDict[reqStatus_code] = 1111 as AnyObject
            
            if reqTask != nil
            {
                self.delegate!.dataRecievedFromServer(responseData: errorDict as NSDictionary, withTask: reqTask)
            }
            showNoInternetConnection()
        }
    }
}
