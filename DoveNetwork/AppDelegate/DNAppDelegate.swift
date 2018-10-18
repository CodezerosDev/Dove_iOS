//
//  AppDelegate.swift
//  DoveNetwork
//
//  Created by Reus on 06/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class DNAppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var navController: UINavigationController?
    
    var isBuyPlanRunning:Bool  = false
    var isSellPlanRunning:Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        IQKeyboardManager.sharedManager().enable = true
        // start location...
        _ = DNLocationManager.sharedInstance
        
        if isKeyPresentInUserDefaults(key: Login_User_user_id)
        {
            if isKeyPresentInUserDefaults(key: Login_User_walletList)
            {
                if isKeyPresentInUserDefaults(key: Login_User_pin)
                {
                    self.loadDashboardScreen()
                }
                else
                {
                    self.loadSetUpPinScreen()
                }
            }
            else
            {
                self.loadWalletScreen()
            }
        }
        else
        {
            self.loadWelcomeScreen()
        }
        return true
    }
    
    func loadWelcomeScreen()
    {
        let welcomeVC = DNConstant.StoryBoards.authentication.instantiateViewController(withIdentifier: String(describing:DNWelcomeVC.self)) as! DNWelcomeVC
        navController = UINavigationController.init(rootViewController: welcomeVC)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func loadWalletScreen()
    {
        let walletVC = DNConstant.StoryBoards.wallet.instantiateViewController(withIdentifier: String(describing:DNCreateWalletVC.self)) as! DNCreateWalletVC
        navController = UINavigationController.init(rootViewController: walletVC)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func loadSetUpPinScreen()
    {
        let walletVC = DNConstant.StoryBoards.wallet.instantiateViewController(withIdentifier: String(describing:DNPinVC.self)) as! DNPinVC
        navController = UINavigationController.init(rootViewController: walletVC)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func loadDashboardScreen()
    {
        let walletVC = DNConstant.StoryBoards.dashboard.instantiateViewController(withIdentifier: String(describing:DNDashBoardVC.self)) as! DNDashBoardVC
        navController = UINavigationController.init(rootViewController: walletVC)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DoveNetwork")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext ()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

