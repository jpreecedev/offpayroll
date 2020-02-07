//
//  AgentsVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 07/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

class AgentsVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activeViewSwitch: UISwitch!
    @IBOutlet weak var activeViewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var allAgents = [FairAgent]()
    var filteredAgents = [FairAgent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string: "https://offpayroll.org.uk/api/agents/fairagents")!
        
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Array<AnyObject> {
                for fairAgent in dict {
                    let name = fairAgent["name"] as! String
                    let isConsultancy = fairAgent["isConsultancy"] as! Bool
                    let description = fairAgent["shortDescription"] as! String
                    let customImageUrl = fairAgent["customLogoUrl"] as? String
                    let slug = fairAgent["slug"] as! String
                    
                    self.allAgents.append(FairAgent(name: name, isConsultancy: isConsultancy, description: description, customImageUrl: customImageUrl, slug: slug))
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        activeViewLabel.text = sender.isOn ? "Showing only fair IR35 agents" : "Showing all agents"
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeViewSwitch.isOn ? allAgents.count : filteredAgents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let agent = activeViewSwitch.isOn ? allAgents[indexPath.row] : filteredAgents[indexPath.row]
         
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AgentTableViewCell") as? AgentTableViewCell {
            cell.configureCell(agent: agent)
            return cell
        }
        
        return UITableViewCell()
    }
}
