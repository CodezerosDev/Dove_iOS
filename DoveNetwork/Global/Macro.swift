//
//  Macro.swift
//  Genemobility
//
//  Created by webclues-mac on 12/04/18.
//  Copyright © 2018 webclues-mac. All rights reserved.
//

import Foundation
import UIKit

let SERVER_URL  = "http://dove.network/dashboard/public/web_service/"
let SERVER_URL1  = "http://webcluestech.com/qa/dove_network/public/web_service/"

let reqStatus = "status"
let reqStatus_code = "status_code"
let reqMessage = "message"
let reqData = "data"

let reqTask_registerStep1 = "register_step1"
let reqTask_resendOTP = "resendotp"
let reqTask_registerStep2 = "register_step2"
let reqTask_setupPin = "setup_pin"
let reqTask_createWallet = "keyether_create_wallet"
let reqTask_walletBalance = "np_address_balance"
let reqTask_exportWallet = "keyether_export_wallet"
let reqTask_importWallet = "keyether_import_wallet"
let reqTask_importWalletFromAddress = "keyether_privatekeytopublickey"

let Login_User_Detail = "LoginDetail"
let Login_User_auth_token = "auth_token"
let Login_User_user_id = "user_id"
let Login_User_phoneNumber = "user_phoneNumber"
let Login_User_pin = "user_pin"
let Login_User_walletList = "user_walletList"

let Wallet_password = "password"
let Wallet_default = "default"
let Wallet_Type = "type"
let Wallet_balance = "balance"
let Wallet_privateKey = "privateKey"
let Wallet_publicKey = "publicKey"
let Wallet_salf = "salf"
let Wallet_iv = "iv"
let Wallet_name = "name"

// --------------------------- Static ---------------------------
let DEVICE_ID =  UIDevice.current.identifierForVendor!.uuidString
let DEVICE_TYPE = 2
var TAG_Device_Token = "device_token"

let TAG_DateFormate = "dd/MM/yyyy"
let TAG_DateFormate_Server = "dd/MM/yyyy"
let UploadDoc_DateFormate = "yyyy-MM-dd"

let trip_DateFormate = "MMM d, h:mm a"

let availab_DateFormate = "yyyy-MM-dd"
let availab_TimeFormate = "hh:mm a"
let availab_TimeFormateServer = "HH:mm:ss"

let test_availab_date = "yyyy-MM-dd"
let test_availab_startTime = "00:00 AM"
let test_availab_endTime = "00:00: PM"

let FONT_NAME_BOLD                       = "SFUIText-BoldG1"
let FONT_NAME_SEMIBOLD                   = "SFUIText-Semibold"
let FONT_NAME_MEDIUM                     = "SFUIText-Medium"
let FONT_NAME_REGULAR                    = "SFUIText-Regular"
let FONT_NAME_LIGHT                      = "SFUIText-Light"

let FONT_SIZE_FULLBIG: CGFloat        =   24.0
let FONT_SIZE_EXTRABIG: CGFloat       =   22.0
let FONT_SIZE_BIG: CGFloat            =   20.0
let FONT_SIZE_EXTRANORMAL: CGFloat    =   18.0
let FONT_SIZE_NORMAL: CGFloat         =   16.0
let FONT_SIZE_SMALL: CGFloat          =   14.0
let FONT_SIZE_EXTRASMALL: CGFloat     =   12.0
let FONT_SIZE_FULLSMALL: CGFloat     =   10.0

let LENGTH_MIN_PASSWORD: Int    =   8
let LENGTH_PASSWORD: Int        =   20

let APPLICATION_DELEGATE = UIApplication.shared.delegate as! DNAppDelegate

let APP_NAME = "Dove Netowrk"
let Alert_Ok = "Ok"
let Alert_Cancel = "Cancel"
let Alert_Yes = "Yes"
let Alert_No = "No"

// ------------------------ For Device Size ------------------------
struct SCREEN_SIZE
{
    static let WIDTH = UIScreen.main.bounds.size.width
    static let HEIGHT = UIScreen.main.bounds.size.height
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

// ------------------------ For App Image ------------------------
struct IMG
{
    static let GasStation = UIImage(named: "gas_station")
    static let Menu = UIImage(named: "menu")
    static let FuelStation = UIImage(named: "bl_fuel")

    static let Back = UIImage(named: "back")
    static let Close = UIImage(named: "ic_close")

    static let Pickup = UIImage(named: "ic_pickup")
    static let Dropoff = UIImage(named: "ic_dropoff")
    static let DriverCar = UIImage(named: "map_car")
    static let PickupPin = UIImage(named: "pickup_pin")
    static let DropPin = UIImage(named: "drop_pin")

    static let StarYellow = UIImage(named: "star_yellow")
    static let DemoProfile = UIImage(named: "demo_profile")
    
}

// ------------------------ For App Color ------------------------
struct COLOR
{
    static let spinnerColor = UIColor(red: 253.0/255.0, green: 172.0/255.0, blue: 9.0/255.0, alpha: 1.0);
}
