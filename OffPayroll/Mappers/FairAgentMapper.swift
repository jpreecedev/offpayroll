//
//  AgentMapper.swift
//  OffPayroll
//
//  Created by Jon Preece on 09/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import Foundation

class FairAgentMapper {
    
    private static func mapStandardFields(data: AnyObject) -> FairAgent {
        let name = data["name"] as! String
        let isConsultancy = data["isConsultancy"] as! Bool
        let shortDescription = data["shortDescription"] as! String
        let slug = data["slug"] as! String
        
        let fairAgent = FairAgent(name: name, isConsultancy: isConsultancy, shortDescription: shortDescription, slug: slug)
        fairAgent.customLogoUrl = data["customLogoUrl"] as? String
        fairAgent.specialisms = data["specialisms"] as? String
        fairAgent.locations = data["locations"] as? String
        fairAgent.determinationMethod = data["determinationMethod"] as? String
        fairAgent.thirdParties = data["thirdParties"] as? String
        fairAgent.appealsProcess = data["appealsProcess"] as? String
        fairAgent.insurances = data["insurances"] as? String
        fairAgent.examples = data["examples"] as? String
        fairAgent.jobSearchName = data["jobSearchName"] as? String
        fairAgent.reviewSearchName = data["reviewSearchName"] as? String
        fairAgent.websiteUrl = data["websiteUrl"] as? String
        
        return fairAgent
    }
    
    static func mapFromAPI(data: AnyObject) -> FairAgent {
        return mapStandardFields(data: data)
    }
    
    static func mapFromAPI(data: AnyObject, existingAgent: FairAgent) -> FairAgent {
        
        let fairAgent = mapStandardFields(data: data)
        fairAgent.image = existingAgent.image
        
        return fairAgent
    }
    
}
