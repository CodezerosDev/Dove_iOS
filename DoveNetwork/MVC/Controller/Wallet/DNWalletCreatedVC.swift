//
//  DNWalletCreatedVC.swift
//  DoveNetwork
//
//  Created by Reus on 11/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNWalletCreatedVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
    
    @IBAction func backTapped(_ sender: UIButton)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton)
    {
        let pinVC  = DNConstant.StoryBoards.wallet.instantiateViewController(withIdentifier: String(describing: DNPinVC.self)) as! DNPinVC
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(pinVC, animated: true)
        }
    }
}
