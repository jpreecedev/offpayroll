//
//  CommentTableViewCell.swift
//  OffPayroll
//
//  Created by Jon Preece on 04/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var situationIcon: UIImageView!
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(comment: Comment) {
        switch comment.situation {
        case "ban":
            situationLabel.text = "PAYE / umbrella only / no PSCs"
            situationIcon.image = UIImage(named: "error")
            situationLabel.textColor = UIColor(red: 220/255, green: 53/255, blue: 69/255, alpha: 1)
            break
        case "fair":
            situationLabel.text = "Individually / fairly assessed, PSCs available"
            situationIcon.image = UIImage(named: "check-circle-solid")
            situationLabel.textColor = UIColor(red: 40/255, green: 167/255, blue: 69/255, alpha: 1)
            break
        case "unfair":
            situationLabel.text = "Flawed / unfair assessments"
            situationIcon.image = UIImage(named: "exclamation-triangle-solid")
            situationLabel.textColor = UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
            break
        case "exceptions":
            situationLabel.text = "PAYE/umbrella only, with some exceptions"
            situationIcon.image = UIImage(named: "exclamation-triangle-solid")
            situationLabel.textColor = UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
            break
        default:
            situationLabel.text = comment.situationOtherDetails != "" ? "Other: \(comment.situationOtherDetails)" : ""
            situationIcon.image = UIImage(named: "question-circle-solid")
            situationLabel.textColor = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1)
        }
        
        commentDateLabel.text = "\(Date.ToFormattedDateString(date: comment.dateSubmitted))"
        commentLabel.text = comment.comments
    }
}
