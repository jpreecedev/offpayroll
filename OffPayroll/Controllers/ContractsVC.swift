//
//  ContractsVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 11/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

typealias ContractsAPIRequestCompletion = (_ errMsg: String?, _ data: Array<AnyObject>) -> Void

class ContractsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var indicator = UIActivityIndicatorView()
    var contracts = [Contract]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.isHidden = true
        
        startActivityIndicator()
        
        getDataFromAPI(url: URL(string: "https://jobs-api.offpayroll.org.uk/api/jobs/recentoutside")!) { (err, data) in
            for contract in data {
                let newContract = Contract()
                
                newContract.datePosted = Date.FromISOString(dateString: contract["datePosted"] as! String, format: "yyyy-MM-dd'T'HH:mm:ss")
                newContract.hirer = contract["hirer"] as? String
                newContract.title = contract["title"] as? String
                newContract.location = contract["location"] as? String
                newContract.rateFormatted = contract["rateFormatted"] as? String
                newContract.url = contract["url"] as? String
                newContract.likeCount = contract["likeCount"] as? Int
                newContract.shortCount = contract["shortCount"] as? Int
                newContract.reassessCount = contract["reassessCount"] as? Int
                newContract.duplicateCount = contract["duplicateCount"] as? Int
                newContract.otherCount = contract["otherCount"] as? Int
                
                self.contracts.append(newContract)
            }
            self.tableView.reloadData()
            self.stopActivityIndicator()
            self.tableView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contracts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contract = contracts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContractTableViewCell") as? ContractTableViewCell {
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            } else {
                cell.backgroundColor = UIColor.white
            }
            
            cell.layoutMargins = UIEdgeInsets.zero
            cell.configureCell(contract: contract, isAlternateCell: indexPath.row % 2 == 0)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    func getDataFromAPI(url: URL, onComplete: @escaping CompanyDetailsAPIRequestCompletion) {
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
