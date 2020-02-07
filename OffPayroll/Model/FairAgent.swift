//
//  Agent.swift
//  OffPayroll
//
//  Created by Jon Preece on 07/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

class FairAgent {
    
    private var _name: String!
    private var _slug: String!
    private var _image: UIImage!
    private var _description: String!
    private var _isConsultancy: Bool!
    private var _customImageUrl: String?
    
    var image : UIImage? {
        get {
            if let image = _image {
                return image
            }
            return UIImage(named: "building-solid-off")
        }
        set {
            _image = newValue
        }
    }
    
    var description: String {
        return _description
    }
    
    var name: String {
        return _name
    }
    
    var customImageUrl: String? {
        return _customImageUrl
    }
    
    var slug: String {
        return _slug
    }
    
    init(name: String, isConsultancy: Bool, description: String, customImageUrl: String?, slug: String) {
        _name = name
        _isConsultancy = isConsultancy
        _description = description
        _customImageUrl = customImageUrl
        _slug = slug
    }
    
}
