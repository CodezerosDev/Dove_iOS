//
//  Extension.swift
//  Genemobility
//
//  Created by webclues-mac on 12/04/18.
//  Copyright © 2018 webclues-mac. All rights reserved.
//

import Foundation
import UIKit

// ------------------------------------------------------------- For NSDictionary to Json String ---------------------------------------------------------------------
extension NSDictionary
{
    func JSONString() -> NSString
    {
        var jsonString: NSString = ""
        var jsonData: NSData!
        
        do
        {
            jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0)) as NSData!
        }
        catch let error as NSError
        {
            print(error)
        }
        
        jsonString = NSString.init(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)!
        
        return jsonString
    }
}

// ------------------------------------------------------------- For NSArray to Json String ---------------------------------------------------------------------
extension NSArray
{
    func JSONString() -> NSString
    {
        var jsonString: NSString = ""
        var jsonData: NSData!
        
        do
        {
            jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0)) as NSData!
        }
        catch let error as NSError
        {
            print(error)
        }
        
        jsonString = NSString.init(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)!
        
        return jsonString
    }
}


extension String
{
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var removeSpace: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func format(_ seprator: String) -> String {
        let src = self
        var dst = [String]()
        var i = 1
        for char in src {
            let mod = i % 4
            dst.append(String(char))
            if mod == 0 {
                dst.append(seprator)
            }
            i += 1
        }
        return dst.joined(separator: "")
    }
}

extension UITextField
{
    func setLeftPaddingPoints(_ amount:CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }

}
