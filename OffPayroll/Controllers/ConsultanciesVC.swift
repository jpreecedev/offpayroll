//
//  ConsultanciesVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 08/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

class ConsultanciesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
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
            for fairAgent in data {
                let name = fairAgent["name"] as! String
                let isConsultancy = fairAgent["isConsultancy"] as! Bool
                let description = fairAgent["shortDescription"] as! String
                let customImageUrl = fairAgent["customLogoUrl"] as? String
                let slug = fairAgent["slug"] as! String
                
                if (isConsultancy) {
                    self.fairAgents.append(FairAgent(name: name, isConsultancy: isConsultancy, description: description, customImageUrl: customImageUrl, slug: slug))
                }
            }
            
            self.tableView.reloadData()
            self.stopActivityIndicator()
            self.tableView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fairAgents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AgentTableViewCell") as? AgentTableViewCell {
            cell.layoutMargins = UIEdgeInsets.zero
            cell.configureCell(fairAgent: fairAgents[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
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
