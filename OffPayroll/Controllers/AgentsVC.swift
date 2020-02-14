//
//  AgentsVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 07/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

typealias AgentsAPIRequestCompletion = (_ errMsg: String?, _ data: Array<AnyObject>) -> Void

class AgentsVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activeViewSwitch: UISwitch!
    @IBOutlet weak var activeViewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var allAgents = [Agent]()
    var fairAgents = [FairAgent]()
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.isHidden = true
        
        startActivityIndicator()
        
        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/agents/fairagents")!) { (err, data) in
            for item in data {
                let agent = FairAgentMapper.mapFromAPI(data: item)
                
                if (!agent.isConsultancy) {
                    self.fairAgents.append(agent)
                }
            }
            
            self.tableView.reloadData()
            self.stopActivityIndicator()
            self.tableView.isHidden = false
        }
        
        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/agents")!) { (err, data) in
            for agent in data {
                let name = agent["name"] as! String
                let reviewSituations = agent["reviewSituations"] as! [String]
                
                self.allAgents.append(Agent(name: name, reviewSituations: reviewSituations))
            }
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        activeViewLabel.text = sender.isOn ? "Showing only fair IR35 agents" : "Showing all agents"
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeViewSwitch.isOn ? fairAgents.count : allAgents.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (activeViewSwitch.isOn) {
            performSegue(withIdentifier: "ConsultancyDetailsSegue", sender: fairAgents[indexPath.row])
        } else {
            performSegue(withIdentifier: "AgentDetailsSegue", sender: allAgents[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AgentTableViewCell") as? AgentTableViewCell {
            cell.layoutMargins = UIEdgeInsets.zero
            if activeViewSwitch.isOn {
                cell.configureCell(fairAgent: fairAgents[indexPath.row])
            } else {
                cell.configureCell(agent: allAgents[indexPath.row])
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConsultancyDetailsVC {
            vc.agent = sender as! FairAgent
        }
        if let vc = segue.destination as? AgentDetailsVC {
            vc.agent = sender as! Agent
        }
    }
    
    func getDataFromAPI(url: URL, onComplete: @escaping AgentsAPIRequestCompletion) {
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Array<AnyObject> {
                onComplete(nil, dict)
            }
        }
    }
    
    func startActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        indicator.backgroundColor = .white
    }
    
    func stopActivityIndicator() {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
}
