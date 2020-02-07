//
//  File.swift
//  OffPayroll
//
//  Created by Jon Preece on 02/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

class Company {
    
    private var _name: String!
    private var _slug: String!
    private var _commentCount: Int!
    private var _image : UIImage!
    
    var name :  String {
        return _name
    }
    
    var slug: String {
        return _slug
    }
    
    var commentCount: Int {
        return _commentCount
    }
    
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
    
    init(name: String, slug : String, commentCount: Int) {
        _name = name
        _slug = slug
        _commentCount = commentCount
    }
    
}
