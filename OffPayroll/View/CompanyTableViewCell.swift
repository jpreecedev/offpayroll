//
//  CompanyTableViewCell.swift
//  OffPayroll
//
//  Created by Jon Preece on 02/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var statuses: UIStackView!
    @IBOutlet weak var overallStatus: UIImageView!
    
    private var _company: Company!
    
    var company: Company {
        return _company
    }
    
    func configureCell(company: Company) {
        _company = company
        companyName.text = company.name
        numberOfComments.text = "\(company.commentCount)"
        
        if let situation = company.situation {
            switch situation {
            case "ban":
                overallStatus.image = UIImage(named: "error")
                break
            case "fair":
                overallStatus.image = UIImage(named: "check-circle-solid")
                break
            case "unfair":
                overallStatus.image = UIImage(named: "exclamation-triangle-solid")
                break
            case "exceptions":
                overallStatus.image = UIImage(named: "exclamation-triangle-solid")
                break
            case "permie":
                overallStatus.image = UIImage(named: "error")
                break
            default:
                overallStatus.image = UIImage(named: "question-circle-solid")
                break
            }
        }
        
        for view in statuses.subviews{
            view.removeFromSuperview()
        }
        
        if let situations = company.last12Reviews {
            for situation in situations {
                statuses.addArrangedSubview(StatusView.create(status: situation))
            }
        }
        
        let url = URL(string: "https://logo.clearbit.com/\(company.slug)?size=141")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                if let data = data, let companyLogo = UIImage(data: data) {
                    self.companyLogo.image = companyLogo
                    self._company.image = companyLogo
                }
            }
        }
    }
}
