//
//  AgentMapper.swift
//  OffPayroll
//
//  Created by Jon Preece on 09/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import Foundation

class FairAgentMapper {
    
    static func mapFromAPI(data: AnyObject) -> FairAgent {
        
        let name = data["name"] as! String
        let isConsultancy = data["isConsultancy"] as! Bool
        let shortDescription = data["shortDescription"] as! String
        let slug = data["slug"] as! String
        
        let fairAgent = FairAgent(name: name, isConsultancy: isConsultancy, shortDescription: shortDescription, slug: slug)
        fairAgent.customLogoUrl = data["customLogoUrl"] as? String
        
        return fairAgent
    }
    
    static func mapFromAPI(data: AnyObject, existingAgent: FairAgent) -> FairAgent {
        
        let name = data["name"] as! String
        let isConsultancy = data["isConsultancy"] as! Bool
        let shortDescription = data["shortDescription"] as! String
        let slug = data["slug"] as! String
        
        let fairAgent = FairAgent(name: name, isConsultancy: isConsultancy, shortDescription: shortDescription, slug: slug)
        fairAgent.customLogoUrl = data["customLogoUrl"] as? String
        fairAgent.image = existingAgent.image
        
        return fairAgent
    }
    
}
