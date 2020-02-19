//
//  StatusView.swift
//  OffPayroll
//
//  Created by Jon Preece on 19/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit


@IBDesignable
class StatusView: UIView {
    
    @IBInspectable var status: String = "unknown" {
        willSet {
            
            switch newValue {
            case "fair":
                backgroundColor = UIColor(red: 40/255, green:167/255, blue:69/255, alpha: 1)
                self.layer.borderColor = UIColor(red: 169/255, green:220/255, blue:181/255, alpha: 1).cgColor
                break
            case "ban", "permie":
                backgroundColor = UIColor(red: 220/255, green:53/255, blue:69/255, alpha: 1)
                self.layer.borderColor = UIColor(red: 241/255, green:174/255, blue:181/255, alpha: 1).cgColor
                break
            case "unfair", "exceptions":
                backgroundColor = UIColor(red: 255/255, green:193/255, blue:7/255, alpha: 1)
                self.layer.borderColor = UIColor(red: 255/255, green:230/255, blue:156/255, alpha: 1).cgColor
                break
            default:
                backgroundColor = UIColor(red: 216/255, green:216/255, blue:216/255, alpha: 1)
                self.layer.borderColor = UIColor(red: 236/255, green:236/255, blue:236/255, alpha: 1).cgColor
                break
            }
            
        }
    }
    
    static func create(status: String) -> StatusView {
        let statusView = StatusView()
        statusView.status = status
        statusView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        return statusView
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
    }
    
}
