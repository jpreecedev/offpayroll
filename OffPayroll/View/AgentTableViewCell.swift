//
//  AgentTableViewCell.swift
//  OffPayroll
//
//  Created by Jon Preece on 07/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

typealias ImageDownloadCompletion = (_ errMsg: String?, _ logo: UIImage) -> Void

class AgentTableViewCell: UITableViewCell {

    @IBOutlet weak var agentImage: UIImageView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var agentDescription: UILabel!
    @IBOutlet weak var statuses: UIStackView!

    private var _fairAgent: FairAgent!
    private var _agent: Agent!

    var fairAgent: FairAgent {
        return _fairAgent
    }

    var agent: Agent {
        return _agent
    }

    func configureCell(agent: Agent) {
        _agent = agent
        agentName.text = agent.name

        agentDescription.text = ""
        agentImage.image = nil

        if (statuses != nil) {
            statuses.isHidden = false
            for view in statuses.subviews{
              view.removeFromSuperview()
            }
            if let situations = agent.last12Reviews {
                for situation in situations {
                    statuses.addArrangedSubview(StatusView.create(status: situation))
                }
            }
        }
    }

    func configureCell(fairAgent: FairAgent) {

        _fairAgent = fairAgent
        agentName.text = fairAgent.name
        agentDescription.text = fairAgent.shortDescription
        agentImage.isHidden = false

        if (statuses != nil) {
            statuses.isHidden = true
        }

        var url: URL!
        if (fairAgent.customLogoUrl == nil) {
            url = URL(string: "https://logo.clearbit.com/\(fairAgent.slug)?size=141")
        } else {
            url = URL(string: fairAgent.customLogoUrl!)
        }

        downloadImage(url: url, onComplete: { (err, data) in guard err != nil else {
            self.agentImage.image = data
            self._fairAgent.image = data
            return
            }
        })
    }

    func downloadImage(url: URL, onComplete: @escaping ImageDownloadCompletion) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let data = data, let companyLogo = UIImage(data: data) {
                    onComplete(nil, companyLogo)
                }
            }
        }
    }

}
