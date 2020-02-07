//
//  AgentsVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 07/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

typealias APIRequestCompletion = (_ errMsg: String?, _ data: Array<AnyObject>) -> Void

class AgentsVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activeViewSwitch: UISwitch!
    @IBOutlet weak var activeViewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var allAgents = [Agent]()
    var fairAgents = [FairAgent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/agents/fairagents")!, onComplete: { (err, data) in guard err != nil else {
            for fairAgent in data {
                let name = fairAgent["name"] as! String
                let isConsultancy = fairAgent["isConsultancy"] as! Bool
                let description = fairAgent["shortDescription"] as! String
                let customImageUrl = fairAgent["customLogoUrl"] as? String
                let slug = fairAgent["slug"] as! String
                
                self.fairAgents.append(FairAgent(name: name, isConsultancy: isConsultancy, description: description, customImageUrl: customImageUrl, slug: slug))
            }
            
            self.tableView.reloadData()
            return
            }
        })
        
        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/agents")!, onComplete: { (err, data) in guard err != nil else {
            for agent in data {
                let name = agent["name"] as! String
                let reviewSituations = agent["reviewSituations"] as! [String]
                
                self.allAgents.append(Agent(name: name, reviewSituations: reviewSituations))
            }
            
            self.tableView.reloadData()
            return
            }
        })
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        activeViewLabel.text = sender.isOn ? "Showing only fair IR35 agents" : "Showing all agents"
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeViewSwitch.isOn ? fairAgents.count : allAgents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AgentTableViewCell") as? AgentTableViewCell {
            if activeViewSwitch.isOn {
                cell.configureCell(fairAgent: fairAgents[indexPath.row])
            } else {
                cell.configureCell(agent: allAgents[indexPath.row])
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getDataFromAPI(url: URL, onComplete: @escaping APIRequestCompletion) {
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Array<AnyObject> {
                onComplete(nil, dict)
            }
        }
    }
}
