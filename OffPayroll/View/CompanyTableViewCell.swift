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
    
    private var _company: Company!
    
    var company: Company {
        return _company
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(company: Company) {
        _company = company
        companyName.text = company.name
        numberOfComments.text = "\(company.commentCount)"
        
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
