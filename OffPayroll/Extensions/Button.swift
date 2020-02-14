//
//  Button.swift
//  OffPayroll
//
//  Created by Jon Preece on 14/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

@IBDesignable extension UIButton {

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

}
