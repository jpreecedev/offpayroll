//
//  FlagAProblemVC.swift
//  OffPayroll
//
//  Created by Jon Preece on 15/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import UIKit

class FlagAProblemVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var fullDescriptionLabel: UILabel!
    @IBOutlet weak var flagAProblemTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var goBackBtn: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    private var _offPayrollService = OffPayrollService()
    private var _contract: Contract!
    private var _selectedValue = "IR35 status likely to change"
    
    private let _pickerItems: Dictionary<String, String> = [
        "IR35 status likely to change": "The advert suggests the status will be reassessed / changed",
        "It's a duplicate": "You've seen this already on this site",
        "Short contract length": "The advert suggests it could end before April 2020",
        "Something else": "This may be published on this page - keep it clean (see the rules on the website)"
    ]
    
    var contract: Contract {
        get {
            return _contract
        }
        set {
            _contract = newValue
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        if _selectedValue == "Something else" && (descriptionTextField.text == nil || descriptionTextField.text == "") {
            presentAlert(title: "Missing Data", message: "Please let us know why where is a problem with this contract", completion: {_ in })
            return
        }
        
        var reason: String
        switch _selectedValue {
        case "IR35 status likely to change":
            reason = "reassess"
            break
        case "It's a duplicate":
            reason = "duplicate"
            break
        case "Short contract length":
            reason = "short"
            break
        case "Something else":
            reason = "other"
            break
        default:
            reason = ""
            break
        }
        
        _offPayrollService.flagAProblem(contractId: contract.id!, reason: reason, furtherDetails: descriptionTextField.text) {
            self.presentAlert(title: "Feedback Sent", message: "Thank you, your feedback has been sent to us", completion: { _ in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        companyNameLabel.text = contract.title
        fullDescriptionLabel.text = _pickerItems["IR35 status likely to change"]
    }
    
    func presentAlert(title: String, message: String, completion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: completion))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(_pickerItems.keys.sorted { $0.lowercased() < $1.lowercased() })[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = Array(_pickerItems.keys.sorted { $0.lowercased() < $1.lowercased() })[row]
        
        fullDescriptionLabel.text = _pickerItems[selectedItem]
        flagAProblemTextField.isHidden = selectedItem != "Something else"
        _selectedValue = selectedItem
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
