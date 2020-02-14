//
//  ContractDetails.swift
//  OffPayroll
//
//  Created by Jon Preece on 14/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import Foundation

class ContractDetails {
    private var _id: Int?
    private var _datePosted: Date?
    private var _description: String?
    private var _hirer: String?
    private var _ir35Status: String?
    private var _location: String?
    private var _title: String?
    private var _url: String?
    private var _rateFormatted: String?
    private var _likeCount: Int?
    private var _shortCount: Int?
    private var _reassessCount: Int?
    private var _duplicateCount: Int?
    private var _otherCount: Int?
    
    var id: Int? {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var datePosted: Date? {
        get {
            return _datePosted
        }
        set {
            _datePosted = newValue
        }
    }
    
    var description: String? {
        get {
            return _description
        }
        set {
            _description = newValue
        }
    }
    
    var hirer: String? {
        get {
            return _hirer
        }
        set {
            _hirer = newValue
        }
    }
    
    var ir35Status: String? {
        get {
            return _ir35Status
        }
        set {
            _ir35Status = newValue
        }
    }
    
    var title: String? {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    var location: String? {
        get {
            return _location
        }
        set {
            _location = newValue
        }
    }
    
    var rateFormatted: String? {
        get {
            return _rateFormatted
        }
        set {
            _rateFormatted = newValue
        }
    }
    
    var url: String? {
        get {
            return _url
        }
        set {
            _url = newValue
        }
    }
    
    var likeCount: Int? {
        get {
            return _likeCount
        }
        set {
            _likeCount = newValue
        }
    }
    
    var shortCount: Int? {
        get {
            return _shortCount
        }
        set {
            _shortCount = newValue
        }
    }
    
    var reassessCount: Int? {
        get {
            return _reassessCount
        }
        set {
            _reassessCount = newValue
        }
    }
    
    var duplicateCount: Int? {
        get {
            return _duplicateCount
        }
        set {
            _duplicateCount = newValue
        }
    }
    
    var otherCount: Int? {
        get {
            return _otherCount
        }
        set {
            _otherCount = newValue
        }
    }
}
