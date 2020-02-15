//
//  ConsultancyDetailsVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 09/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

typealias AgencyAPIRequestCompletion = (_ errMsg: String?, _ data: [Comment]) -> Void


class AgentDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var agentLogo: UIImageView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var agentBlurbLabel: UILabel!
    
    private var _agent: Agent!
    var comments = [Comment]()
    var indicator = UIActivityIndicatorView()
    
    var agent: Agent {
        get {
            return _agent
        }
        set {
            _agent = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.isHidden = true
        
        startActivityIndicator()
        
        agentLogo.image = UIImage(named: "building-solid-off")
        agentName.text = _agent.name
        agentBlurbLabel.text = "Latest insights of \(_agent.name) from contractors and consultants"
        
        print( "https://offpayroll.org.uk/api/agents/\(_agent.name)")
        
        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/agents/\(_agent.name.replacingOccurrences(of: " ", with: "%20"))")!) { (err, data) in
            for comment in data {
                self.comments.append(comment)
            }
            self.tableView.reloadData()
            self.stopActivityIndicator()
            self.tableView.isHidden = false
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getDataFromAPI(url: URL, onComplete: @escaping AgencyAPIRequestCompletion) {
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                var commentsResult = [Comment]()
                
                if let comments = dict["comments"] as? Array<AnyObject> {
                    for comment in comments {
                        let dateSubmitted = Date.FromISOString(dateString: comment["dateSubmitted"] as! String, format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
                        let situation = comment["situation"] as! String
                        let situationOtherDetails = comment["situationOtherDetails"] as! String
                        let commentText = "\"\((comment["comments"] as! String).trimmingCharacters(in: .whitespacesAndNewlines))\""
                        commentsResult.append(Comment(situation: situation, situationOtherDetails: situationOtherDetails, comments: commentText, dateSubmitted: dateSubmitted))
                    }
                }
                
                onComplete(nil, commentsResult)
            }
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
