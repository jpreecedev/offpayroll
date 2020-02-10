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
    private var _customLogoUrl: String?
    private var _websiteUrl: String?
    private var _shortDescription: String!
    private var _specialisms: String?
    private var _locations: String?
    private var _determinationMethod: String?
    private var _thirdParties: String?
    private var _appealsProcess: String?
    private var _insurances: String?
    private var _examples: String?
    private var _jobSearchName: String?
    private var _reviewSearchName: String?
    private var _isConsultancy: Bool!
    
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
    
    var shortDescription: String {
        return _shortDescription
    }
    
    var name: String {
        return _name
    }
    
    var customLogoUrl: String? {
        get {
            return _customLogoUrl
        }
        set {
            _customLogoUrl = newValue
        }
    }
    
    var slug: String {
        return _slug
    }
    
    var specialisms: String? {
        get {
            return _specialisms
        }
        set {
            _specialisms = newValue
        }
    }
    
    var locations: String? {
        get {
            return _locations
        }
        set {
            _locations = newValue
        }
    }
    
    var determinationMethod: String? {
        get {
            return _determinationMethod
        }
        set {
            _determinationMethod = newValue
        }
    }
    
    var thirdParties: String? {
        get {
            return _thirdParties
        }
        set {
            _thirdParties = newValue
        }
    }
    
    var appealsProcess: String? {
        get {
            return _appealsProcess
        }
        set {
            _appealsProcess = newValue
        }
    }
    
    var insurances: String? {
        get {
            return _insurances
        }
        set {
            _insurances = newValue
        }
    }
    
    var examples: String? {
        get {
            return _examples
        }
        set {
            _examples = newValue
        }
    }
    
    var jobSearchName: String? {
        get {
            return _jobSearchName
        }
        set {
            _jobSearchName = newValue
        }
    }
    
    var reviewSearchName: String? {
        get {
            return _reviewSearchName
        }
        set {
            _reviewSearchName = newValue
        }
    }
    
    var isConsultancy: Bool {
        get {
            return _isConsultancy
        }
        set {
            _isConsultancy = newValue
        }
    }
    
    init(name: String, isConsultancy: Bool, shortDescription: String, slug: String) {
        _name = name
        _isConsultancy = isConsultancy
        _shortDescription = shortDescription
        _slug = slug
    }
    
}
