//
//  ViewController.swift
//  OffPayroll
//
//  Created by Jon Preece on 31/01/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string: "https://offpayroll.org.uk/api/companies")!
        
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? [Dictionary<String, AnyObject>] {
                for company in dict {
                    let name = company["name"] as! String
                    let slug = company["slug"] as! String
                    let commentCount = company["commentCount"] as! Int
                    self.companies.append(Company(name: name, slug: slug, commentCount: commentCount))
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = companies[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell") as? CompanyTableViewCell {
            cell.configureCell(company: Company(name: company.name, slug: company.slug, commentCount: company.commentCount))
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}

