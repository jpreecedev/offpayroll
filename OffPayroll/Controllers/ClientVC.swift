//
//  ClientVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 02/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

class ClientVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var _company: Company!
    
    var comments = [Comment]()
    
    var company: Company {
        get {
            return _company
        }
        set {
            _company = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        selectedLabel.text = _company.name
        companyLogo.image = _company.image
        
        let url = URL(string: "https://offpayroll.org.uk/api/companies/\(_company.slug)")!
        
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if  let reviews = dict["reviews"] as? Array<AnyObject>  {
                    for review in reviews {
                        let dateSubmitted = Date.FromISOString(dateString: review["dateSubmitted"] as! String)
                        let situation = review["situation"] as! String
                        let situationOtherDetails = review["situationOtherDetails"] as! String
                        let comments = "\"\((review["comments"] as! String).trimmingCharacters(in: .whitespacesAndNewlines))\""
                        self.comments.append(Comment(situation: situation, situationOtherDetails: situationOtherDetails, comments: comments, dateSubmitted: dateSubmitted))
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell {
            cell.configureCell(comment: comment)
            return cell
        }
        
        return UITableViewCell()
    }
    
}
