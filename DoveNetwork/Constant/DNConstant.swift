//
//  DNConstant.swift
//  DoveNetwork
//
//  Created by Reus on 07/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNConstant: NSObject
{
    static let appDelegate = UIApplication.shared.delegate as! DNAppDelegate
    
    struct StoryBoards
    {
        static let authentication   = UIStoryboard(name: "Auth", bundle: nil)
        static let wallet           = UIStoryboard(name: "Wallet", bundle: nil)
        static let dashboard        = UIStoryboard(name: "Dashboard", bundle: nil)
        static let buyData          = UIStoryboard(name: "BuyData", bundle: nil)
        static let sellData         = UIStoryboard(name: "SellData", bundle: nil)
    }
    
    struct Xibs
    {
        static let favPlanView        = Bundle.main.loadNibNamed(String(describing: DNFavPlan.self), owner: self, options: nil)![0] as! DNFavPlan
        static let recentPlanView     = Bundle.main.loadNibNamed(String(describing: DNRecentPlanView.self), owner: self, options: nil)![0] as! DNRecentPlanView
        static let confirmation       = Bundle.main.loadNibNamed(String(describing: DNConfirmView.self), owner: self, options: nil)![0] as! DNConfirmView
        static let historyDetail      = Bundle.main.loadNibNamed(String(describing: DNHistoryDetailView.self), owner: self, options: nil)![0] as! DNHistoryDetailView
        static let deleteWallet       = Bundle.main.loadNibNamed(String(describing: DNWalletDeleteView.self), owner: self, options: nil)![0] as! DNWalletDeleteView
        static let importWallet       = Bundle.main.loadNibNamed(String(describing: DNImportWalletView.self), owner: self, options: nil)![0] as! DNImportWalletView
        static let importWalletConfirmation = Bundle.main.loadNibNamed(String(describing: DNImportWalletConfirmationView.self), owner: self, options: nil)![0] as! DNImportWalletConfirmationView
        static let exportWallet       = Bundle.main.loadNibNamed(String(describing: DNExportWalletView.self), owner: self, options: nil)![0] as! DNExportWalletView
        static let enterNameWallet       = Bundle.main.loadNibNamed(String(describing: DNEnterNameWalletView.self), owner: self, options: nil)![0] as! DNEnterNameWalletView
    }

    struct Controllers
    {
        let buySellData = StoryBoards.buyData.instantiateViewController(withIdentifier: String(describing: DNDataSellBuyVC.self)) as! DNDataSellBuyVC
        let buyData = StoryBoards.buyData.instantiateViewController(withIdentifier: String(describing: DNBuyDataTblVC.self)) as! DNBuyDataTblVC
    }
    
    struct ProcedureCellsID
    {
        static let duration   = "DNDurationCell"
        static let repeatt    = "DNRepeattCell"
        static let price      = "DNPriceCell"
        
        static let cellsArray = [ProcedureCellsID.duration, ProcedureCellsID.repeatt, ProcedureCellsID.price]
    }
    
    struct HistoryCellID
    {
        static let buying    = "DNBuyHistoryCell"
        static let selling   = "DNSellnigHistoryCell"
    }
    
    struct PlansCellID
    {
        static let buyPlan  = "DNBuyingPlansCell"
        static let sellPlan = "DNSellingPlansCell"
    }
}
