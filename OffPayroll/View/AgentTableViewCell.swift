//
//  AgentTableViewCell.swift
//  OffPayroll
//
//  Created by Jon Preece on 07/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

class AgentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var agentImage: UIImageView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var agentDescription: UILabel!
    
    private var _agent: FairAgent!
    
    var agent: FairAgent {
        return _agent
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(agent: FairAgent) {
        
        _agent = agent
        agentName.text = agent.name
        agentDescription.text = agent.description
        
        var url: URL?
        if (agent.customImageUrl == nil) {
            url = URL(string: "https://logo.clearbit.com/\(agent.slug)?size=141")
        } else {
            url = URL(string: agent.customImageUrl!)
        }
        
        if let url = url {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let data = data, let companyLogo = UIImage(data: data) {
                        self.agentImage.image = companyLogo
                        self._agent.image = companyLogo
                    }
                }
            }
        }
        
    }
    
}
