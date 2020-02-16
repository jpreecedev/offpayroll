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
    @IBOutlet weak var contractsTabBarItem: UITabBarItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var subscriptionTitleLabel: UILabel!
    @IBOutlet weak var subscribeBtn: UIButton!

    var indicator = UIActivityIndicatorView()
    var contracts = OrderedDictionary<String, [Contract]>()
    var subscriptionsService = EmailSubscriptionService()

    let sectionHeaderHeight: CGFloat = 35

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.isHidden = true

        updateSubscriptionUI()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContractsVC.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        startActivityIndicator()

        getDataFromAPI(url: URL(string: "https://jobs-api.offpayroll.org.uk/api/jobs/recentoutside")!) { (err, data) in
            var contracts = [Contract]()

            for contract in data {
                let newContract = Contract(date: contract["datePosted"] as! String)

                newContract.id = contract["id"] as? Int32
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

                contracts.append(newContract)
            }

            self.contracts = ContractsMapper.mapFromDictionary(contracts: Dictionary(grouping: contracts, by: { Date.ToFormattedDateString(date: $0.datePosted) }))

            self.contractsTabBarItem.badgeValue = "\(contracts.count)"
            self.contractsTabBarItem.badgeColor = UIColor(red: 40/255, green:167/255, blue:69/255, alpha: 1)
            self.tableView.reloadData()
            self.stopActivityIndicator()
            self.tableView.isHidden = false
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return contracts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(contracts)[section].value.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        view.backgroundColor = UIColor(red: 209/255, green:228/255, blue:253/255, alpha: 1)

        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: sectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.text = Array(contracts)[section].key

        view.addSubview(label)
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContractTableViewCell") as? ContractTableViewCell {

            let contract: Contract = Array(contracts)[indexPath.section].value[indexPath.row]

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ContractDetailsVC {
            if let cell = sender as? ContractTableViewCell {
                vc.contract = cell.contract
            }
        }
    }

    @IBAction func subscribeBtnPressed(_ sender: Any) {

        if subscriptionsService.hasSubscribed() {
            if let email = emailTextField.text {
                subscriptionsService.unsubscribe(emailAddress: email) {
                    self.updateSubscriptionUI()
                }
            }

        } else {
            if let email = emailTextField.text {
                subscriptionsService.subscribe(emailAddress: email) {
                    self.updateSubscriptionUI()
                }
            }
        }

    }

    func updateSubscriptionUI() {
        if subscriptionsService.hasSubscribed() {
            subscribeBtn.setTitle("Unsubscribe", for: .normal)
            emailTextField.isHidden = true
            subscriptionTitleLabel.text = "Unsubscribe at any time"
        } else {
            subscribeBtn.setTitle("Subscribe", for: .normal)
            emailTextField.isHidden = false
            subscriptionTitleLabel.text = "Subscribe for daily updates"
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
