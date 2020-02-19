//
//  StatusHeadingIndicatorView.swift
//  OffPayroll
//
//  Created by Jon Preece on 19/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

@IBDesignable
class StatusHeadingIndicatorView: UIView {
    
    @IBInspectable var status: String? = "unknown" {
        willSet {
            
            switch newValue {
            case "fair":
                backgroundColor = UIColor(red: 222/255, green:245/255, blue:245/255, alpha: 1)
                break
            case "ban", "permie":
                backgroundColor = UIColor(red: 246/255, green:228/255, blue:229/255, alpha: 1)
                break
            case "unfair", "exceptions":
                backgroundColor = UIColor(red: 254/255, green:250/255, blue:239/255, alpha: 1)
                break
            default:
                backgroundColor = UIColor(red: 240/255, green:240/255, blue:240/255, alpha: 1)
                break
            }
            
        }
    }
    
}
