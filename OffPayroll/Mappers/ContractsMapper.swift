//
//  ContractsMapper.swift
//  OffPayroll
//
//  Created by Jon Preece on 16/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import Foundation

class ContractsMapper {
    
    static func mapFromDictionary(contracts: Dictionary<String, [Contract]>) -> OrderedDictionary<String, [Contract]> {
        var result = OrderedDictionary<String, [Contract]>()
        
        let keys = Array(contracts.keys).map{ Date.FromAbbreviatedString(date: $0) }.sorted(by: { $0 > $1 })
        
        for key in keys {
            let formattedAgain = Date.ToFormattedDateString(date: key)
            result[formattedAgain] = contracts[formattedAgain]
        }
        
        return result
    }
    
}
