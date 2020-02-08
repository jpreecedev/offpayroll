//
//  NotificationView.swift
//  OffPayroll
//
//  Created by Jon Preece on 08/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 184/255, green: 218/255, blue: 255/255, alpha: 1).cgColor
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }

}
