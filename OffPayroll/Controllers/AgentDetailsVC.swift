//
//  AgentDetailsVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 09/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit
import Alamofire

typealias AgentDetailsAPIRequestCompletion = (_ errMsg: String?, _ data: Dictionary<String, AnyObject>) -> Void

class AgentDetailsVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!

    @IBOutlet weak var specialismsHeaderLabel: UILabel!
    @IBOutlet weak var specialismsLabel: UILabel!
    @IBOutlet weak var locationsHeaderLabel: UILabel!
    @IBOutlet weak var locationsLabel: UILabel!
    @IBOutlet weak var statusDeterminationHeaderLabel: UILabel!
    @IBOutlet weak var statusDeterminationLabel: UILabel!
    @IBOutlet weak var thirdPartiesHeaderLabel: UILabel!
    @IBOutlet weak var thirdPartiesLabel: UILabel!
    @IBOutlet weak var appealsProcessHeaderLabel: UILabel!
    @IBOutlet weak var appealsProcessLabel: UILabel!
    @IBOutlet weak var insurancesHeaderLabel: UILabel!
    @IBOutlet weak var insurancesLabel: UILabel!
    @IBOutlet weak var approachHeaderLabel: UILabel!
    @IBOutlet weak var approachLabel: UILabel!
    
    private var _agent: FairAgent!
    var indicator = UIActivityIndicatorView()
    
    var agent: FairAgent {
        get {
            return _agent
        }
        set {
            _agent = newValue
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
        
        companyName.text = _agent.name
        companyLogo.image = _agent.image
        
        getDataFromAPI(url: URL(string: "https://offpayroll.org.uk/api/agents/\(_agent.name.replacingOccurrences(of: " ", with: "%20"))")!) { (err, data) in
            self.agent = FairAgentMapper.mapFromAPI(data: data as AnyObject, existingAgent: self._agent)
            
            self.companyLogo.image = self.agent.image
            self.companyName.text = self.agent.name
            
            self.toggleControl(headerLabel: self.specialismsHeaderLabel, bodyLabel: self.specialismsLabel, value: self.agent.specialisms)
            self.toggleControl(headerLabel: self.locationsHeaderLabel, bodyLabel: self.locationsLabel, value: self.agent.locations)
            self.toggleControl(headerLabel: self.statusDeterminationHeaderLabel, bodyLabel: self.statusDeterminationLabel, value: self.agent.determinationMethod)
            self.toggleControl(headerLabel: self.thirdPartiesHeaderLabel, bodyLabel: self.thirdPartiesLabel, value: self.agent.thirdParties)
            self.toggleControl(headerLabel: self.appealsProcessHeaderLabel, bodyLabel: self.appealsProcessLabel, value: self.agent.appealsProcess)
            self.toggleControl(headerLabel: self.insurancesHeaderLabel, bodyLabel: self.insurancesLabel, value: self.agent.insurances)
            self.toggleControl(headerLabel: self.approachHeaderLabel, bodyLabel: self.approachLabel, value: self.agent.examples)
            
            self.stopActivityIndicator()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentCtrl.selectedSegmentIndex {
        case 0:
            break;
        default:
            break;
        }
    }
    
    func getDataFromAPI(url: URL, onComplete: @escaping AgentDetailsAPIRequestCompletion) {
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if  let fairAgentData = dict["fairAgent"] as? Dictionary<String, AnyObject>  {
                    onComplete(nil, fairAgentData)
                }
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