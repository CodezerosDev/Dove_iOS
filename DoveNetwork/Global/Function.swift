//
//  Function.swift
//  Genemobility
//
//  Created by webclues-mac on 12/04/18.
//  Copyright © 2018 webclues-mac. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

// --------------------------- For Internet Check ---------------------------
func isInternetAvailable() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress)
    {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
    {
        return false
    }
    
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}

// --------------------------- For Email Validation ---------------------------
func emailValidation(strEmail: String) -> Bool
{
    var isValidate: Bool
    let email : String = strEmail.lowercased()
    //let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailRegEx = "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    isValidate = emailTest.evaluate(with: email)
    return isValidate
}

func enterTimeEmailValidation(strEmail: String) -> Bool
{
    var isValidate: Bool
    let email : String = strEmail.lowercased()
    let emailRegEx = "[A-Z0-9a-z._@%+-]*"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    isValidate = emailTest.evaluate(with: email)
    return isValidate
}

// --------------------------- For Name Validation ---------------------------

func enterTimeNameValidation(strName: String) -> Bool
{
    var isValidate: Bool
    let email : String = strName.lowercased()
    let emailRegEx = "[A-Za-zàâäèéêëîïôœùûüÿçÀÂÄÈÉÊËÎÏÔŒÙÛÜŸÇء-ي]*\\s*"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    isValidate = emailTest.evaluate(with: email)
    return isValidate
}

// --------------------------- For Price Validation ---------------------------

func enterTimePriceValidation(strPrice: String) -> Bool
{
    var isValidate: Bool
    let email : String = strPrice.lowercased()
    let emailRegEx = "[0-9]{0,8}+[.]{0,1}+[0-9]{0,8}"
    //let emailRegEx = "[0-9.]*"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    isValidate = emailTest.evaluate(with: email)
    return isValidate
}

func PriceValidation(strPrice: String) -> Bool
{
    var isValidate: Bool
    let email : String = strPrice.lowercased()
    let emailRegEx = "[0-9]{0,8}+[.]{0,1}+[0-9]{0,8}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    isValidate = emailTest.evaluate(with: email)
    return isValidate
}

// --------------------------- For Phone no Validation ---------------------------
func phoneFormatValidation(strPhone: String, PHONE_REGEX: String) -> Bool
{
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    return phoneTest.evaluate(with: strPhone)
}

func phoneNoValidation(strPhone: String) -> Bool
{
    //let PHONE_REGEX = "\\+?[0-9]{8,13}"
    //let PHONE_REGEX = "[0-9]{10}"
    let PHONE_REGEX = "[0-9]{8,13}"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: strPhone)
    return result
}

func enterTimePhoneValidation(strPhone: String) -> Bool
{
    var isValidate: Bool
    let email : String = strPhone.lowercased()
    let emailRegEx = "^(?:(?:\\+|0{0,2})91(\\s*[\\ -]\\s*)?|[0]?)?[789]\\d{9}|(\\d[ -]?){9}\\d$"
    //let emailRegEx = "[0-9.]*"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    isValidate = emailTest.evaluate(with: email)
    return isValidate
}
// --------------------------- For Password Validation ---------------------------

func passwordValidation(strPassword: String) -> Bool
{
    //"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,}$"
    //let PASSWORD_REGEX = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,13}$"
    let PASSWORD_REGEX = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{\(LENGTH_MIN_PASSWORD),\(LENGTH_PASSWORD)}$"
    //let PASSWORD_REGEX = "[A-Za-z\\d$@$!%*#?&]{\(LENGTH_MIN_PASSWORD),\(LENGTH_PASSWORD)}"

    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PASSWORD_REGEX)
    let result =  phoneTest.evaluate(with: strPassword)
    return result
}

// --------------------------- For Display Alert ---------------------------

func showAlertViewController(message:String)
{
    if let presentController = APPLICATION_DELEGATE.navController!.topViewController
    {
        let alertController = UIAlertController(title: APP_NAME, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: Alert_Ok, style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(saveAction)
        presentController.present(alertController, animated: true, completion: nil)
    }
}

func showNoInternetConnection()
{
    if let presentController = APPLICATION_DELEGATE.window?.rootViewController 
    {
        let alertController = UIAlertController(title: APP_NAME, message: "No internet connection".localized, preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: Alert_Ok, style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(saveAction)
        presentController.present(alertController, animated: true, completion: nil)
    }
    /*if let topController = UIApplication.topViewController()
    {
        if topController is NoNetViewController
        {
            
        }
        else
        {
            let noNetVC = topController.storyboard?.instantiateViewController(withIdentifier: "NoNetViewController") as! NoNetViewController
            topController.present(noNetVC, animated: true, completion: nil)
        }
    }*/
}

// --------------------------- For Textfiled toolbar on top ---------------------------
func textfieldToolBar(txtField: UITextField, delegate: AnyObject)
{
    let keyboardDoneButtonView = UIToolbar()
    let spaceButton = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: delegate, action: Selector(("toolBarDoneClicked")))
    keyboardDoneButtonView.sizeToFit()
    keyboardDoneButtonView.items = [spaceButton, doneButton]
    
    txtField.inputAccessoryView = keyboardDoneButtonView
}

// --------------------------- For Textfiled toolbar on top ---------------------------
func textviewToolBar(txtView: UITextView, delegate: AnyObject)
{
    let keyboardDoneButtonView = UIToolbar()
    let spaceButton = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: delegate, action: Selector(("toolBarDoneClicked")))
    keyboardDoneButtonView.sizeToFit()
    keyboardDoneButtonView.items = [spaceButton, doneButton]
    
    txtView.inputAccessoryView = keyboardDoneButtonView
}

func sortArrayWithKey(arrSort:NSArray, strKeyname: String, isAscending: Bool) -> NSArray
{
    let descriptor: NSSortDescriptor = NSSortDescriptor(key: strKeyname, ascending: isAscending)
    let sortedResults = arrSort.sortedArray(using: [descriptor]) as NSArray
    
    return sortedResults
}

// ---------------------------- For Get device country code ---------------------------
func getDeviceCountryCode() -> String
{
    var strCountryCode: String = ""
    
    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
    {
        print(countryCode)
        
        let path = Bundle.main.path(forResource: "countries", ofType: "json")
        let jsonData : NSData = NSData(contentsOfFile: path!)!
        
        var jsonArr : NSArray!
        do
        {
            jsonArr = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }
        catch let error as NSError
        {
            print(error)
        }
        
        let predicate = NSPredicate(format: "code == %@", countryCode)
        let filteredArray: [Any]! = jsonArr.filtered(using: predicate)
        
        let dictTemp: NSDictionary = filteredArray[0] as! NSDictionary
        print(dictTemp)
        
        strCountryCode = dictTemp.value(forKey: "dial_code") as! String
    }
    
    return strCountryCode
}

func getCurrentDate() -> String
{
    let strCurrentDate: String = ConvertDateToString(date: Date(), formate: TAG_DateFormate)
    return strCurrentDate
}

func convertDateStringtoDeviceTime (msgDate: String) -> String
{
    let dateFormatter = DateFormatter()
    let timeZone = NSTimeZone(name: "UTC")
    dateFormatter.timeZone = timeZone as TimeZone?
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
    let date: Date? = dateFormatter.date(from: msgDate)
    let dateNew = Date(timeIntervalSinceNow: (date?.timeIntervalSinceNow)!)
    let dateString: String = ConvertDateToString(date: dateNew, formate: "dd-MM-yyyy HH:mm")
    return dateString
}

func convertDatetoDeviceTime (selectedDate: Date) -> String
{
    let dateNew = Date(timeIntervalSinceNow: (selectedDate.timeIntervalSinceNow))
    let dateString: String = ConvertDateToString(date: dateNew, formate: "dd-MM-yyyy HH:mm")
    return dateString
}

//func addBorderAtBottom(sender: AnyObject)
//{
//    let bottomLayer: CALayer! = CALayer()
//    bottomLayer.frame = CGRect(x: 0, y: sender.frame.size.height-1, width: sender.frame.size.width, height: 1.0)
//   // bottomLayer.backgroundColor = COLOR.borderColor.cgColor
//    sender.layer.addSublayer(bottomLayer)
//}

func addShadowEffect(sender: AnyObject)
{
    sender.layer.shadowColor = UIColor.black.cgColor
    sender.layer.shadowOpacity = 0.3
    sender.layer.shadowOffset = CGSize(width: 1, height: 1)
    sender.layer.shadowRadius = 2
}

func addDarkShadowEffect(sender: AnyObject)
{
    sender.layer.shadowColor = UIColor.black.cgColor
    sender.layer.shadowOpacity = 0.3
    sender.layer.shadowOffset = CGSize(width: -2, height: 2)
    sender.layer.shadowRadius = 4
}

func randomNumber(MIN: Int, MAX: Int)-> Int
{
    return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
}

func getLoginUserDict() -> NSDictionary
{
    var dictUser: NSDictionary! = NSDictionary()
    
    if let dictTemp = UserDefaults.standard.value(forKey: Login_User_Detail) as? NSDictionary
    {
        dictUser = dictTemp
    }
    
    return dictUser
}

func isKeyPresentInUserDefaults(key: String) -> Bool
{
    return UserDefaults.standard.object(forKey: key) != nil
}

func getStringUserDefaults(Key:String) -> String
{
    var value: String = ""
    
    if let keyValue = UserDefaults.standard.value(forKey: Key) as? String
    {
        value = keyValue
    }
    return value
}

func SetUserDefaults(Key:String,value:AnyObject)
{
    let userDefaults : UserDefaults = UserDefaults.standard
    userDefaults.setValue(value, forKey: Key)
    userDefaults.synchronize()
}

func RemoveUserDefaults(Key:String)
{
    let userDefaults : UserDefaults = UserDefaults.standard
    userDefaults.removeObject(forKey: Key)
    userDefaults.synchronize()
}

func GetUserDefaults(Key:String) -> AnyObject
{
    var value: AnyObject!
    
    if let keyValue = UserDefaults.standard.value(forKey: Key)
    {
        value = keyValue as AnyObject
    }
    return value
}

func convertToDictionary(text: String) -> NSDictionary
{
    if let data = text.data(using: .utf8)
    {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        } catch {
            print(error.localizedDescription)
        }
    }
    return NSDictionary()
}

func GetDatefromTimestamp(timestamp:Double) -> Date
{
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return dateFormatter.date(from: strDate)!
}

func ConvertDateToString(date:Date, formate:String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formate
    return dateFormatter.string(from: date)
}

func ConvertStringToDate(date:String, formate:String) -> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formate
    return dateFormatter.date(from: date)!
}

func getCurrentISODateString() -> String
{
    let dateFormatter = DateFormatter()
    let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH_mm_ss.sss"
    let iso8601String = dateFormatter.string(from: Date())
    return "\(iso8601String)Z"
}

func generateQRCode(strText: String) -> UIImage
{
    var imgQRCode: UIImage = UIImage()
    let data = strText.data(using: String.Encoding.isoLatin1)
    
    if let filter = CIFilter(name: "CIQRCodeGenerator")
    {
        filter.setValue(data, forKey: "inputMessage")
        let image: CIImage = filter.outputImage!
        let transform = CGAffineTransform(scaleX: 2, y: 2)
        let outputImage: CIImage = image.transformed(by: transform)
        imgQRCode = UIImage(ciImage: outputImage)
    }
    return imgQRCode
}

// for wallet
func setDefaultWallet(dictWallet: NSMutableDictionary)
{
    let userDefaults : UserDefaults = UserDefaults.standard
    var arrWallet: NSMutableArray!
    
    if isKeyPresentInUserDefaults(key: Login_User_walletList)
    {
        arrWallet = (userDefaults.value(forKey: Login_User_walletList) as! NSArray).mutableCopy() as! NSMutableArray
    }
    else
    {
        arrWallet = NSMutableArray()
    }
    
    if arrWallet.count > 0
    {
        if !arrWallet.contains(dictWallet)
        {
            for i in 0..<arrWallet.count
            {
                let dictTemp: NSMutableDictionary = (arrWallet.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                if "\(dictTemp.value(forKey: Wallet_default)!)" == "1"
                {
                    dictTemp.setValue("0", forKey: Wallet_default)
                    arrWallet.replaceObject(at: i, with: dictTemp)
                }
            }
            arrWallet.add(dictWallet)
        }
    }
    else
    {
        arrWallet.add(dictWallet)
    }
    userDefaults.setValue(arrWallet, forKey: Login_User_walletList)
    userDefaults.synchronize()
}

func getDefaultWallet() -> NSMutableDictionary
{
    let userDefaults : UserDefaults = UserDefaults.standard
    var arrWallet: NSMutableArray!
    var dictDefaultWallet: NSMutableDictionary!
    
    if isKeyPresentInUserDefaults(key: Login_User_walletList)
    {
        arrWallet = (userDefaults.value(forKey: Login_User_walletList) as! NSArray).mutableCopy() as! NSMutableArray
    }
    else
    {
        arrWallet = NSMutableArray()
    }
    
    if arrWallet.count > 0
    {
        for i in 0..<arrWallet.count
        {
            let dictTemp: NSMutableDictionary = (arrWallet.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            if "\(dictTemp.value(forKey: Wallet_default)!)" == "1"
            {
                dictDefaultWallet = dictTemp
                break
            }
        }
    }
    else
    {
        dictDefaultWallet = NSMutableDictionary()
    }
    return dictDefaultWallet
}

func getWalletList() -> NSMutableArray
{
    let userDefaults : UserDefaults = UserDefaults.standard
    var arrWallet: NSMutableArray!
    
    if isKeyPresentInUserDefaults(key: Login_User_walletList)
    {
        arrWallet = (userDefaults.value(forKey: Login_User_walletList) as! NSArray).mutableCopy() as! NSMutableArray
    }
    else
    {
        arrWallet = NSMutableArray()
    }
    
    return arrWallet
}

func saveWalletList(arrList: NSMutableArray)
{
    let userDefaults : UserDefaults = UserDefaults.standard
    userDefaults.setValue(arrList, forKey: Login_User_walletList)
    userDefaults.synchronize()
}
