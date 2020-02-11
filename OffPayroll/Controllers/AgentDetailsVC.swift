//
//  AgentDetailsVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 09/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

typealias AgentDetailsAPIRequestCompletion = (_ errMsg: String?, _ data: AgentDetailsResult) -> Void

struct AgentDetailsResult {
    var fairAgent: FairAgent
    var comments: [Comment]
}

class AgentDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    @IBOutlet weak var specialismsHeaderLabel: UILabel!
    @IBOutlet weak var specialismsLabel: UILabel!
    @IBOutlet weak var locationsHeaderLabel: UILabel!
    @IBOutlet weak var locationsLabel: UILabel!
    @IBOutlet weak var statusDeterminationHeaderLabel: UILabel!
    @IBOutlet weak var statusDeterminationLabel: UILabel!
    @IBOutlet weak var thirdPartiesHeaderLabel: UILabel!
    @IBOutlet weak var thirdPartiesLabel: UILabel!
    @IBOutlet weak var appealsProcessHeaderLabel: UILabel!
    @IBOutlet weak var appealsProcessLabel: UILabel!
    @IBOutlet weak var insurancesHeaderLabel: UILabel!
    @IBOutlet weak var insurancesLabel: UILabel!
    @IBOutlet weak var approachHeaderLabel: UILabel!
    @IBOutlet weak var approachLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var _agent: FairAgent!
    var indicator = UIActivityIndicatorView()
    var comments = [Comment]()
    
    var agent: FairAgent {
        get {
            return _agent
        }
        set {
            _agent = newValue
        }
    }
    
    func toggleControl(headerLabel: UILabel!, bodyLabel: UILabel!, value: String?) {
        headerLabel.isHidden = value == nil
        bodyLabel.isHidden = value == nil
        bodyLabel.text = value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivityIndicator()
        
        companyName.text = _agent.name
        companyLogo.image = _agent.image
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/agents/\(_agent.name.replacingOccurrences(of: " ", with: "%20"))")!) { (err, data) in
            self.agent = data.fairAgent
            self.comments = data.comments
            
            self.tableView.reloadData()
            
            self.companyLogo.image = self.agent.image
            self.companyName.text = self.agent.name
            
            self.toggleControl(headerLabel: self.specialismsHeaderLabel, bodyLabel: self.specialismsLabel, value: self.agent.specialisms)
            self.toggleControl(headerLabel: self.locationsHeaderLabel, bodyLabel: self.locationsLabel, value: self.agent.locations)
            self.toggleControl(headerLabel: self.statusDeterminationHeaderLabel, bodyLabel: self.statusDeterminationLabel, value: self.agent.determinationMethod)
            self.toggleControl(headerLabel: self.thirdPartiesHeaderLabel, bodyLabel: self.thirdPartiesLabel, value: self.agent.thirdParties)
            self.toggleControl(headerLabel: self.appealsProcessHeaderLabel, bodyLabel: self.appealsProcessLabel, value: self.agent.appealsProcess)
            self.toggleControl(headerLabel: self.insurancesHeaderLabel, bodyLabel: self.insurancesLabel, value: self.agent.insurances)
            self.toggleControl(headerLabel: self.approachHeaderLabel, bodyLabel: self.approachLabel, value: self.agent.examples)
            
            self.stopActivityIndicator()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentCtrl.selectedSegmentIndex {
        case 1:
            break;
        case 2:
            scrollView.isHidden = true
            tableView.isHidden = false
            break;
        default:
            scrollView.isHidden = false
            tableView.isHidden = true
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell {
            cell.layoutMargins = UIEdgeInsets.zero
            cell.configureCell(comment: comment)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getDataFromAPI(url: URL, onComplete: @escaping AgentDetailsAPIRequestCompletion) {
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                let fairAgent = FairAgentMapper.mapFromAPI(data: dict["fairAgent"] as AnyObject, existingAgent: self._agent)
                var commentsResult = [Comment]()
                
                if let comments = dict["comments"] as? Array<AnyObject> {
                    for comment in comments {
                        let dateSubmitted = Date.FromISOString(dateString: comment["dateSubmitted"] as! String)
                        let situation = comment["situation"] as! String
                        let situationOtherDetails = comment["situationOtherDetails"] as! String
                        let commentText = "\"\((comment["comments"] as! String).trimmingCharacters(in: .whitespacesAndNewlines))\""
                        commentsResult.append(Comment(situation: situation, situationOtherDetails: situationOtherDetails, comments: commentText, dateSubmitted: dateSubmitted))
                    }
                }
                
                onComplete(nil, AgentDetailsResult(fairAgent: fairAgent, comments: commentsResult))
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
