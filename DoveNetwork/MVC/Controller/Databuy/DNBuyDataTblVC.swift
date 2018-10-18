//
//  DNBuyDataTblVC.swift
//  DoveNetwork
//
//  Created by Reus on 11/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit
import NetworkExtension

class DNBuyDataTblVC: UITableViewController
{
    @IBOutlet weak var viewFavPlans: UIView!
    @IBOutlet weak var viewRecentPlan: UIView!
    @IBOutlet weak var constraintRecentH: NSLayoutConstraint!
    
    @IBOutlet weak var lblVoulme: UILabel!
    var recentPlanView = DNConstant.Xibs.recentPlanView
    
    @IBOutlet weak var btnVoulme: UIButton!
    //MARK: - DropDown's
    
    @IBOutlet weak var chartBuyData: LineChart!
    
    var xValues = [String]()
    
    let chooseVolumeDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseVolumeDropDown
        ]
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupChooseVolumeDropDown()
        
        let dataEntries = generateRandomEntries()
        
        chartBuyData.dataEntries = dataEntries
        chartBuyData.isCurved = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        
        setCommonNavigationBar(title: "", largeTitle: false, tranpernt: false, buttonTint: .black)
        
        let planView = DNConstant.Xibs.favPlanView
        planView.frame = viewFavPlans.bounds
        planView.setBoolBuy = true
        
        viewFavPlans.addSubview(planView)
        
        recentPlanView.frame = viewRecentPlan.bounds
        viewRecentPlan.addSubview(recentPlanView)
        
        recentPlanView.reloadData(showAll: false) { (constraint) in
            DispatchQueue.main.async {
                self.constraintRecentH.constant = constraint + 40
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
        
       // self.scanAvailableWifi()
    }
    
    @IBAction func btnManage(_ sender: UIButton)
    {
        let managePlan = DNConstant.StoryBoards.dashboard.instantiateViewController(withIdentifier: String(describing: DNManagePlansVC.self)) as! DNManagePlansVC
        managePlan.boolBuyingPlans = true
        DispatchQueue.main.async {
            UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.navigationController?.pushViewController(managePlan, animated: false)
            }, completion: nil)
        }
    }
    
    @IBAction func btnViewAll(_ sender: UIButton)
    {
        /*sender.isSelected = !sender.isSelected
         recentPlanView.reloadData(showAll: sender.isSelected) { (constraint) in
         DispatchQueue.main.async {
         self.constraintRecentH.constant = constraint + 40
         self.tableView.beginUpdates()
         self.tableView.endUpdates()
         }
         }*/
        
        let history = DNConstant.StoryBoards.dashboard.instantiateViewController(withIdentifier: String(describing: DNHistoryVC.self)) as! DNHistoryVC
        history.boolBuyingHistory = true
        
        DispatchQueue.main.async {
            UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.navigationController?.pushViewController(history, animated: false)
            }, completion: nil)
        }
    }
    
    @IBAction func btnContinue(_ sender: UIButton)
    {
        let buyDataProceedure = DNConstant.StoryBoards.buyData.instantiateViewController(withIdentifier: String(describing: DNBuyProceedureVC.self)) as! DNBuyProceedureVC
        let navEditorViewController: UINavigationController = UINavigationController(rootViewController: buyDataProceedure)
        DispatchQueue.main.async {
            self.present(navEditorViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnVolumeDropDown(_ sender: UIButton)
    {
        chooseVolumeDropDown.show()
    }
    
//    func scanAvailableWifi()
//    {
//        self.openWifiSetting()
//
//        var options = [String: NSObject]()
//        options[kNEHotspotHelperOptionDisplayName] = "DoveNetwork" as NSObject?
//        NSLog("Lets register", "")
//        _ = NEHotspotHelper.register(options: options, queue: DispatchQueue.main, handler: {(_ cmd: NEHotspotHelperCommand) -> Void in
//            NSLog("Returned", "")
//            print(cmd)
//            if cmd.commandType == NEHotspotHelperCommandType.evaluate || cmd.commandType == NEHotspotHelperCommandType.filterScanList
//            {
//                if cmd.networkList != nil
//                {
//                    for network: NEHotspotNetwork in cmd.networkList!
//                    {
//                        NSLog("Found network \(network.bssid) with \(network.ssid)", "")
//
//                        if (network.ssid == "Parth’s iPhone")
//                        {
//                            print("Confidence set to high for ssid:\(network.ssid)")
//
//                            let hotSpotConfiguration: NEHotspotConfiguration = NEHotspotConfiguration.init(ssid: "Parth’s iPhone", passphrase: "pdpatel1991", isWEP: false)
//                            NEHotspotConfigurationManager.shared.apply(hotSpotConfiguration) { (error) in
//
//                                print(error)
//                            }
//                        }
//                    }
//                }
//            }
//        })
//
//        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(checkDataUsage), userInfo: nil, repeats: true)
//    }
    
    @objc func checkDataUsage()
    {
        print("SystemDataUsage.wifiCompelete",SystemDataUsage.wifiCompelete)
        print("SystemDataUsage.wifiCompelete",SystemDataUsage.wwanCompelete)
        print("SystemDataUsage.getDataUsage",SystemDataUsage.getDataUsage())
    }
    
    func openWifiSetting()
    {
        let url1: NSURL = NSURL(string: "App-Prefs:root=WIFI")!
        let url2: NSURL = NSURL(string: "prefs:root=WIFI")!
        let url3: NSURL = NSURL(string: UIApplicationOpenSettingsURLString)!
        
        if UIApplication.shared.canOpenURL(url1 as URL)
        {
            UIApplication.shared.open(url1 as URL, options: [:], completionHandler: { success in
            })
        }
        else if UIApplication.shared.canOpenURL(url2 as URL)
        {
            UIApplication.shared.open(url2 as URL, options: [:], completionHandler: { success in
            })
        }
        else if UIApplication.shared.canOpenURL(url3 as URL)
        {
            UIApplication.shared.open(url3 as URL, options: [:], completionHandler: { success in
            })
        }
    }
}

extension DNBuyDataTblVC
{
    func setupChooseVolumeDropDown()
    {
        chooseVolumeDropDown.anchorView = btnVoulme
        // Will set a custom with instead of anchor view width
        //        dropDown.width = 100
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        chooseVolumeDropDown.bottomOffset = CGPoint(x: 0, y: btnVoulme.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseVolumeDropDown.dataSource = [
            "MB",
            "GB"
        ]
        
        // Action triggered on selection
        chooseVolumeDropDown.selectionAction = { [weak self] (index, item) in
            //self?.chooseArticleButton.setTitle(item, for: .normal)
            self?.lblVoulme.text = item
            
        }
        
        //        chooseVolumeDropDown.multiSelectionAction = { [weak self] (indices, items) in
        //            print("Muti selection action called with: \(items)")
        //            if items.isEmpty {
        //               // self?.chooseArticleButton.setTitle("", for: .normal)
        //            }
        //        }
        
    }
}

extension DNBuyDataTblVC
{
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 || indexPath.row == 1
        {
            return DNConstant.appDelegate.isBuyPlanRunning ? 0 : UITableViewAutomaticDimension
        }
        else if indexPath.row == 2 || indexPath.row == 3
        {
            return DNConstant.appDelegate.isBuyPlanRunning ? UITableViewAutomaticDimension : 0
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 || indexPath.row == 1
        {
            return DNConstant.appDelegate.isBuyPlanRunning ? 0 : UITableViewAutomaticDimension
        }
        else if indexPath.row == 2 || indexPath.row == 3
        {
            return DNConstant.appDelegate.isBuyPlanRunning ? UITableViewAutomaticDimension : 0
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
}

extension DNBuyDataTblVC
{
    private func generateRandomEntries() -> [PointEntry]
    {
        var result: [PointEntry] = []
        
        for i in 0..<5
        {
            let value = Int(arc4random() % 30)
            result.append(PointEntry(value: value, label:"\(i + 1)"))
        }
        
        return result
    }
}

extension SystemDataUsage
{
    public static var wifiCompelete: UInt64
    {
        return SystemDataUsage.getDataUsage().wifiSent + SystemDataUsage.getDataUsage().wifiReceived
    }
    
    public static var wwanCompelete: UInt64
    {
        return SystemDataUsage.getDataUsage().wirelessWanDataSent + SystemDataUsage.getDataUsage().wirelessWanDataReceived
    }
}

class SystemDataUsage
{
    private static let wwanInterfacePrefix = "pdp_ip"
    private static let wifiInterfacePrefix = "en"
    
    class func getDataUsage() -> DataUsageInfo
    {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        var dataUsageInfo = DataUsageInfo()
        
        guard getifaddrs(&ifaddr) == 0 else { return dataUsageInfo }
        while let addr = ifaddr
        {
            guard let info = getDataUsageInfo(from: addr) else {
                ifaddr = addr.pointee.ifa_next
                continue
            }
            dataUsageInfo.updateInfoByAdding(info)
            ifaddr = addr.pointee.ifa_next
        }
        
        freeifaddrs(ifaddr)
        
        return dataUsageInfo
    }
    
    private class func getDataUsageInfo(from infoPointer: UnsafeMutablePointer<ifaddrs>) -> DataUsageInfo?
    {
        let pointer = infoPointer
        let name: String! = String(cString: pointer.pointee.ifa_name)
        let addr = pointer.pointee.ifa_addr.pointee
        guard addr.sa_family == UInt8(AF_LINK) else { return nil }
        
        return dataUsageInfo(from: pointer, name: name)
    }
    
    private class func dataUsageInfo(from pointer: UnsafeMutablePointer<ifaddrs>, name: String) -> DataUsageInfo
    {
        var networkData: UnsafeMutablePointer<if_data>?
        var dataUsageInfo = DataUsageInfo()
        
        if name.hasPrefix(wifiInterfacePrefix)
        {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData
            {
                dataUsageInfo.wifiSent += UInt64(data.pointee.ifi_obytes)
                dataUsageInfo.wifiReceived += UInt64(data.pointee.ifi_ibytes)
            }
        }
        else if name.hasPrefix(wwanInterfacePrefix)
        {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData
            {
                dataUsageInfo.wirelessWanDataSent += UInt64(data.pointee.ifi_obytes)
                dataUsageInfo.wirelessWanDataReceived += UInt64(data.pointee.ifi_ibytes)
            }
        }
        return dataUsageInfo
    }
}

struct DataUsageInfo
{
    var wifiReceived: UInt64 = 0
    var wifiSent: UInt64 = 0
    var wirelessWanDataReceived: UInt64 = 0
    var wirelessWanDataSent: UInt64 = 0
    
    mutating func updateInfoByAdding(_ info: DataUsageInfo)
    {
        wifiSent += info.wifiSent
        wifiReceived += info.wifiReceived
        wirelessWanDataSent += info.wirelessWanDataSent
        wirelessWanDataReceived += info.wirelessWanDataReceived
    }
}
