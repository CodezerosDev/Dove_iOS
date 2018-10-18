//
//  DNWelcomeVC.swift
//  DoveNetwork
//
//  Created by Reus on 07/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit

class DNWelcomeVC: UIViewController
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
    
    @IBAction func btnContinueTapped(_ sender: UIButton)
    {
        let register    = DNConstant.StoryBoards.authentication.instantiateViewController(withIdentifier: String(describing: DNRegisterVC.self)) as! DNRegisterVC
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(register, animated: true)
        }
    }
}
