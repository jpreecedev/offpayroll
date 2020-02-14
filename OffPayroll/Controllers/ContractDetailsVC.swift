//
//  ContractDetailsVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 14/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

typealias ContractDetailsAPIRequestCompletion = (_ errMsg: String?, _ data: ContractDetails) -> Void

class ContractDetailsVC: UIViewController {
    
    var indicator = UIActivityIndicatorView()
    var contractDetails = ContractDetails()
    
    
    @IBOutlet weak var hirerHeaderLabel: UILabel!
    @IBOutlet weak var hirerLabel: UILabel!
    @IBOutlet weak var locationHeaderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var rateHeaderLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var sourceHeaderLabel: UILabel!
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var fullDescriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var _contract: Contract!
    
    var contract: Contract {
        get {
            return _contract
        }
        set {
            _contract = newValue
        }
    }
    
    func toggleControl(headerLabel: UILabel!, bodyLabel: UILabel!, value: String?) {
        headerLabel.isHidden = value == nil
        bodyLabel.isHidden = value == nil
        bodyLabel.text = value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivityIndicator()
        
        getDataFromAPI(url: URL(string: "https://jobs-api.offpayroll.org.uk/api/jobs/\(_contract.id!)")!) { (err, data) in
            
            self.contractDetails = data
            
            self.toggleControl(headerLabel: self.hirerHeaderLabel, bodyLabel: self.hirerLabel, value: data.hirer)
            self.toggleControl(headerLabel: self.locationHeaderLabel, bodyLabel: self.locationLabel, value: data.location)
            self.toggleControl(headerLabel: self.rateHeaderLabel, bodyLabel: self.rateLabel, value: data.rateFormatted)
            
            self.sourceHeaderLabel.isHidden = data.url == nil
            self.sourceTextView.isHidden = data.url == nil
            self.sourceTextView.text = data.url
            
            self.fullDescriptionLabel.isHidden = data.description == nil
            self.fullDescriptionLabel.text = data.description
            
            self.scrollView.isHidden = false
            self.stopActivityIndicator()
        }
    }
    
    func getDataFromAPI(url: URL, onComplete: @escaping ContractDetailsAPIRequestCompletion) {
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                let contractDetails = ContractDetails()
                contractDetails.id = dict["id"] as? Int
                contractDetails.datePosted = Date.FromISOString(dateString: dict["datePosted"] as! String, format: "yyyy-MM-dd'T'HH:mm:ss")
                contractDetails.description = dict["description"] as? String
                contractDetails.hirer = dict["hirer"] as? String
                contractDetails.ir35Status = dict["ir35Status"] as? String
                contractDetails.location = dict["location"] as? String
                contractDetails.title = dict["title"] as? String
                contractDetails.url = dict["url"] as? String
                contractDetails.rateFormatted = dict["rateFormatted"] as? String
                contractDetails.likeCount = dict["likeCount"] as? Int
                contractDetails.shortCount = dict["shortCount"] as? Int
                contractDetails.reassessCount = dict["reassessCount"] as? Int
                contractDetails.duplicateCount = dict["duplicateCount"] as? Int
                contractDetails.otherCount = dict["otherCount"] as? Int
                
                onComplete(nil, contractDetails)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
