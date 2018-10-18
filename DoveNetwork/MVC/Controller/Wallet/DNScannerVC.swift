//
//  DNScannerVC.swift
//  DoveNetwork
//
//  Created by Ayush Kanodia on 07/08/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit
import RSBarcodes_Swift

class DNScannerVC: RSCodeReaderViewController
{    
    var barcode: String = ""
    var dispatched: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        self.tapHandler = { point in
            print(point)
        }
        
        // MARK: NOTE: If you want to detect specific barcode types, you should update the types
        var types = self.output.availableMetadataObjectTypes
        // MARK: NOTE: Uncomment the following line remove QRCode scanning capability
        // types = types.filter({ $0 != AVMetadataObject.ObjectType.qr })
        self.output.metadataObjectTypes = types
        
        // MARK: NOTE: If you layout views in storyboard, you should these 3 lines
        for subview in self.view.subviews {
            self.view.bringSubview(toFront: subview)
        }
        
        self.hasTorch()
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched { // triggers for only once
                self.dispatched = true
                for barcode in barcodes {
                    guard let barcodeString = barcode.stringValue else { continue }
                    self.barcode = barcodeString
                    print("Barcode found: type=" + barcode.type.rawValue + " value=" + barcodeString)
                    
                    // MARK: NOTE: break here to only handle the first barcode object
                    break
                }
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       // setPresentedNavigationBar(title: "", largeTitle: false, tranpernt: true, buttonTint: .white)
        //self.dispatched = false
    }
}
