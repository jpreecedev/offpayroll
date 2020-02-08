//
//  NotificationView.swift
//  OffPayroll
//
//  Created by Jon Preece on 08/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

@IBDesignable
class NotificationView: UIView {
    
    @IBInspectable var bgColor: UIColor = UIColor(red: 209/255, green:228/255, blue:253/255, alpha: 1) {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    @IBInspectable var viewBorderColor: UIColor = UIColor(red: 209/255, green:228/255, blue:253/255, alpha: 1) {
        didSet {
            self.layer.borderColor = viewBorderColor.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }

}
