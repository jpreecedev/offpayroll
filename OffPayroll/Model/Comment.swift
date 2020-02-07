//
//  Comment.swift
//  OffPayroll
//
//  Created by Jon Preece on 04/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import Foundation

class Comment {
    
    private var _dateSubmitted: Date!
    private var _situation: String!
    private var _situationOtherDetails: String!
    private var _comments: String!
    
    var dateSubmitted: Date {
        return _dateSubmitted
    }
    
    var situation: String {
        return _situation
    }
    
    var situationOtherDetails: String {
        return _situationOtherDetails
    }
    
    var comments: String {
        return _comments
    }
    
    init(situation: String, situationOtherDetails: String, comments: String, dateSubmitted: Date) {
        _dateSubmitted = dateSubmitted
        _situation = situation
        _situationOtherDetails = situationOtherDetails
        _comments = comments
    }
    
}
