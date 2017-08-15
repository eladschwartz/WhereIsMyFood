//
//  LoginVC.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//


import UIKit
import SinchVerification
import SwiftyJSON
import CountryPicker
import SkyFloatingLabelTextField

class LoginVC: UIViewController, UITextFieldDelegate, CountryPickerDelegate {
    
    @IBOutlet weak var countryCodeText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneText: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    var verification:Verification!
    var countryPickerView: CountryPicker!
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneText.delegate = self
        hideKeyboardWhenTappedAround()
        initControls()
        
    }
    
    @IBAction func sendSmsBtn(_ sender: Any) {
        self.disableUI(true)
        phoneNumber = self.countryCodeText.text! + self.phoneText.text!
        
        //For DEMO only - remove this in production
        if (phoneNumber == "+11") {
            APIManager.shared.getDetailsAndSave(phoneNumber: phoneNumber) { (json) in
                    Helpers.goToScreen(name: "fromPhoneToOrders", sender: self, viewController: self)
            }
            return
        }
        //------------------------------
        
        
        APIManager.shared.isDriverApprvoed(phone: phoneNumber) { (json) in
            //If driver not approved(phone number wasn't found)
            if (json == JSON.null) {
                let errorAlert = Helpers.showErrorAlert(btntext: "OK", message: "Phone number not found - please ask the admin to enable your account")
                self.present(errorAlert, animated: true)
                self.disableUI(false)
                return
            }
            //If phone number found in db -> go to pin code screen
            self.verification = SMSVerification(Config.SINCH_KEY, phoneNumber: self.phoneNumber)
            self.verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                self.disableUI(false)
                if (result.success){
                    Helpers.goToScreen(name: "fromPhoneNumberToPinCode", sender: sender, viewController: self)
                } else {
                    let errorAlert = Helpers.showErrorAlert(btntext: "OK", message: (error?.localizedDescription)!)
                    self.present(errorAlert, animated: true)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "fromPhoneNumberToPinCode") {
            let enterCodeVC = segue.destination as! EnterCodeVC
            enterCodeVC.verification = self.verification
            enterCodeVC.phonenumber = self.phoneNumber
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Disable UI
    func disableUI(_ disable: Bool) {
        var alpha:CGFloat = 1.0
        if (disable) {
            alpha = 0.5
            phoneText.resignFirstResponder()
            spinner.startAnimating()
            let delayTime =
                DispatchTime.now() +
                    Double(Int64(30 * Double(NSEC_PER_SEC)))
                    / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(
                deadline: delayTime, execute:
                { () -> Void in
                    self.disableUI(false)
            })
        }
        else{
            self.phoneText.becomeFirstResponder()
            self.spinner.stopAnimating()
            
        }
        self.phoneText.isEnabled = !disable
        self.smsBtn.isEnabled = !disable
        self.smsBtn.alpha = alpha
    }
    
    func initControls() {
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
        countryPickerView = CountryPicker()
        countryPickerView.countryPickerDelegate = self
        countryPickerView.showPhoneNumbers = true
        countryPickerView.setCountry(code!)
        self.countryCodeText.inputView = countryPickerView
    }
    
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.countryCodeText.text = phoneCode
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}




