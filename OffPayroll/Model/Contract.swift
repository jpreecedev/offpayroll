//
//  Contract.swift
//  OffPayroll
//
//  Created by Jon Preece on 11/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import Foundation

class Contract: Hashable {
    
    static func == (lhs: Contract, rhs: Contract) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    private var _id: Int32?
    private var _datePosted: Date?
    private var _hirer: String?
    private var _title: String?
    private var _location: String?
    private var _rateFormatted: String?
    private var _url: String?
    private var _likeCount: Int?
    private var _shortCount: Int?
    private var _reassessCount: Int?
    private var _duplicateCount: Int?
    private var _otherCount: Int?
    
    var id: Int32? {
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
    
    var hirer: String? {
        get {
            return _hirer
        }
        set {
            _hirer = newValue
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
