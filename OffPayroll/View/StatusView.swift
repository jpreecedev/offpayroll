//
//  StatusView.swift
//  OffPayroll
//
//  Created by Jon Preece on 19/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

enum Statuses: String {
    case red = "red"
    case yellow = "yellow"
    case green = "green"
    case unknown = "unknown"
}

@IBDesignable
class StatusView: UIView {
    
    @IBInspectable var status: String? {
        willSet {
            if let newStatus = Statuses(rawValue: newValue?.lowercased() ?? "") {
                
                switch newStatus {
                case .green:
                    backgroundColor = UIColor(red: 40/255, green:167/255, blue:69/255, alpha: 1)
                    self.layer.borderColor = UIColor(red: 169/255, green:220/255, blue:181/255, alpha: 1).cgColor
                    break
                case .red:
                    backgroundColor = UIColor(red: 220/255, green:53/255, blue:69/255, alpha: 1)
                    self.layer.borderColor = UIColor(red: 241/255, green:174/255, blue:181/255, alpha: 1).cgColor
                    break
                case .yellow:
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
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
    }
    
}
