//
//  Agent.swift
//  OffPayroll
//
//  Created by Jon Preece on 07/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

class Agent {
    
    private var _name: String!
    private var _reviewSituations: [String]!
    
    var name: String {
        return _name
    }
    
    var reviewSituations: [String] {
        return _reviewSituations
    }
    
    var last12Reviews: Array<String>? {
        get {
            if let reviewSituations = _reviewSituations {
                if (reviewSituations.count < 12) {
                    return reviewSituations
                }
                
                return Array(reviewSituations[(reviewSituations.count - 12)...])
            }
            return nil
        }
    }
    
    init(name: String, reviewSituations: [String]) {
        _name = name
        _reviewSituations = reviewSituations
    }
    
}
