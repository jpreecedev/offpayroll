//
//  ContractTableViewCell.swift
//  OffPayroll
//
//  Created by Jon Preece on 02/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

class ContractTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hirerLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    
    func configureCell(contract: Contract, isAlternateCell: Bool) {
        titleLabel.text = contract.title
        locationLabel.text = contract.location
        hirerLabel.text = contract.hirer
        
        if isAlternateCell {
            let color = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            view.backgroundColor = color
        } else {
            view.backgroundColor = UIColor.white
        }
    }
}
