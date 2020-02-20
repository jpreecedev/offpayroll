//
//  MainVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 31/01/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

typealias CompaniesAPIRequestCompletion = (_ errMsg: String?, _ data: [Dictionary<String, AnyObject>]?) -> Void

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shareFeedbackButton: UIButton!
    
    var companies = [Company]()
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
        
        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/companies")!) { (err, data) in
            if let data = data {
                for company in data {
                    let name = company["name"] as! String
                    let slug = company["slug"] as! String
                    let commentCount = company["commentCount"] as! Int
                    let reviewSituations = company["reviewSituations"] as! Array<String>
                    let situation = company["situation"] as? String
                    
                    let newCompany = Company(name: name, slug: slug, commentCount: commentCount)
                    newCompany.reviewSituations = reviewSituations
                    newCompany.situation = situation
                    
                    self.companies.append(newCompany)
                }
            }
            
            self.tableView.reloadData()
            self.stopActivityIndicator()
            self.tableView.isHidden = false
            self.tableView.backgroundView = nil
            
            if err != nil {
                let attachment = NSTextAttachment()
                attachment.image = UIImage(systemName: "exclamationmark.icloud")
                attachment.bounds = CGRect(x: 0, y: 0, width: 100, height: 76)
                let attachmentString = NSAttributedString(attachment: attachment)
                let str = NSMutableAttributedString(string: "")
                str.append(attachmentString)
                str.append(NSAttributedString(string: "\n\nUnable to retrieve data.\nPlease check you are connected to the internet"))
                
                let noDataLabel: UILabel = UILabel()
                noDataLabel.textAlignment = NSTextAlignment.center
                noDataLabel.numberOfLines = 0
                noDataLabel.attributedText = str
                
                self.tableView.backgroundView = noDataLabel
            }
        }
    }
    
    func getDataFromAPI(url: URL, onComplete: @escaping CompaniesAPIRequestCompletion) {
        Alamofire.request(url).responseJSON {
            response in
            guard response.result.isSuccess else {
                if let error = response.error {
                    onComplete(error.localizedDescription, nil)
                }
                return
            }
            let result = response.result
            if let dict = result.value as? [Dictionary<String, AnyObject>] {
                onComplete(nil, dict)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = companies[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell") as? CompanyTableViewCell {
            cell.layoutMargins = UIEdgeInsets.zero
            cell.configureCell(company: company)
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination  as? ClientDetailsVC {
            if let cell = sender as? CompanyTableViewCell {
                vc.company = cell.company
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
    
    @IBAction func shareFeedbackBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://offpayroll.org.uk/lookup")!, options: [:], completionHandler: nil)
    }
}

