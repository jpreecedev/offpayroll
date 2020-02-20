//
//  ConsultanciesVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 08/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

class ConsultanciesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fillOutFormBtn: UIButton!
    
    var fairAgents = [FairAgent]()
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

        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/agents/fairagents")!) { (err, data) in
            for item in data {
                
                let fairAgent = FairAgentMapper.mapFromAPI(data: item)

                if (fairAgent.isConsultancy) {
                    self.fairAgents.append(fairAgent)
                }
            }

            self.tableView.reloadData()
            self.stopActivityIndicator()
            self.tableView.isHidden = false
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fairAgents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AgentTableViewCell") as? AgentTableViewCell {
            cell.layoutMargins = UIEdgeInsets.zero
            cell.configureCell(fairAgent: fairAgents[indexPath.row])
            return cell
        }

        return UITableViewCell()
    }

    func getDataFromAPI(url: URL, onComplete: @escaping AgentsAPIRequestCompletion) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConsultancyDetailsVC {
            if let cell = sender as? AgentTableViewCell {
                vc.agent = cell.fairAgent
            }
        }
    }

    @IBAction func fillOutFormBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://forms.zohopublic.eu/james13/form/OffPayrollorgukagentlisting/formperma/8BNOPSK49dLkg9gWJ6Op61Tr1QBFh2njTZuvsKdxCaU")!, options: [:], completionHandler: nil)
    }
}
