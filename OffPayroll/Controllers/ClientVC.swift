//
//  ClientDetailsVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 02/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

typealias CompanyDetailsAPIRequestCompletion = (_ errMsg: String?, _ data: Array<AnyObject>) -> Void

class ClientDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var _company: Company!
    
    var comments = [Comment]()
    var indicator = UIActivityIndicatorView()
    
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
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.isHidden = true
        selectedLabel.isHidden = true
        
        startActivityIndicator()
        
        selectedLabel.text = _company.name
        companyLogo.image = _company.image
        
        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/companies/\(_company.slug)")!) { (err, data) in
            for review in data {
                let dateSubmitted = Date.FromISOString(dateString: review["dateSubmitted"] as! String, format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
                let situation = review["situation"] as! String
                let situationOtherDetails = review["situationOtherDetails"] as! String
                let comments = "\"\((review["comments"] as! String).trimmingCharacters(in: .whitespacesAndNewlines))\""
                self.comments.append(Comment(situation: situation, situationOtherDetails: situationOtherDetails, comments: comments, dateSubmitted: dateSubmitted))
            }
            self.tableView.reloadData()
            self.stopActivityIndicator()
            self.tableView.isHidden = false
            self.selectedLabel.isHidden = false
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
            cell.layoutMargins = UIEdgeInsets.zero
            cell.configureCell(comment: comment)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getDataFromAPI(url: URL, onComplete: @escaping CompanyDetailsAPIRequestCompletion) {
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if  let reviews = dict["reviews"] as? Array<AnyObject>  {
                    onComplete(nil, reviews)
                }
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
